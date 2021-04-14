import 'package:flutter/material.dart';
import 'package:lv_shop_list/components/lv_add_item_modal.dart'
    show LvAddItemModal;
import 'package:lv_shop_list/components/lv_animated_list.dart'
    show LvAnimatedList;
import 'package:lv_shop_list/components/lv_button.dart' show LvGradientButton;
import 'package:lv_shop_list/components/lv_sliver_app_bar.dart'
    show LvSliverAppBar;
import 'package:lv_shop_list/env/env.dart' show Env;
import 'package:lv_shop_list/models/lv_product.dart' show LvProduct;
import 'package:lv_shop_list/providers/lv_firebase_provider.dart';
import 'package:lv_shop_list/theme/create_color_swatch.dart';
import 'package:lv_shop_list/utils/lv_logger.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

final Future initFirebaseAppFuture = Firebase.initializeApp(
  name: Env.databaseName,
  options: FirebaseOptions(
    appId: Env.appId,
    apiKey: Env.apiKey,
    projectId: Env.projectId,
    databaseURL: Env.databaseUrl,
    messagingSenderId: Env.messagingSenderId, // empty.
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late final FirebaseApp app;
  try {
    app = await initFirebaseAppFuture;
  } on FirebaseException catch (err) {
    if (err.code == 'duplicate-app') {
      app = Firebase.app(Env.databaseName);
    }
  }
  runApp(MyApp(firebaseApp: app));
}

/// [MyApp].
class MyApp extends StatefulWidget {
  final FirebaseApp firebaseApp;

  const MyApp({Key? key, required this.firebaseApp}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

/// [_MyAppState].
class _MyAppState extends State<MyApp> {
  late final LvFirebaseProvider _firebaseProvider;
  late final Future<bool> _initDatabaseFuture;

  @override
  void initState() {
    super.initState();
    this._firebaseProvider = LvFirebaseProvider(this.widget.firebaseApp);
    this._initDatabaseFuture =
        this._firebaseProvider.initialize(enablePersistence: true);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LvFirebaseProvider>.value(value: this._firebaseProvider),
      ],
      child: FutureBuilder<bool>(
        future: this._initDatabaseFuture,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return MaterialApp(
            title: 'LvShoppingList',
            theme: ThemeData(
              fontFamily: 'WorkSans',
              accentColor: Colors.white,
              primarySwatch: createMaterialColor(Color(0xFF6b5eff)),
            ),
            home: MyHomePage(title: 'Carrinho'),
          );
        },
      ),
    );
  }
}

/// [MyHomePage].
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// [_MyHomePageState]
class _MyHomePageState extends State<MyHomePage> {
  /// Add new product.
  void add(BuildContext context) async {
    final newItem = await showDialog(
      context: context,
      useSafeArea: true,
      useRootNavigator: true,
      builder: (context) => AlertDialog(
        title: Text('Add new: '),
        content: LvAddItemModal(),
      ),
    );
    if (newItem != null) {
      if (newItem is LvProduct) {
        logger.d('Adding new item: ${newItem.name}.');
        await context.read<LvFirebaseProvider>().create(newItem);
      }
    } else {
      logger.d('`newItem` is null.');
    }
  }

  /// Clear Basket.
  void removeAll(BuildContext context) async {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    // show confirmation remove dialog.
    final remove = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          title: const Text('Clear All?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: theme.primaryColor),
              child:
                  const Text('Confirm', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (remove != null && remove) {
      final provider = context.read<LvFirebaseProvider>();
      // get snapshot of the entire database data.
      final snapshot = await provider.root.once();
      // removes every item from the list.
      await provider.removeAll();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Undo',
            textColor: theme.primaryColorLight,
            // revert changes.
            onPressed: () async => await context
                .read<LvFirebaseProvider>()
                .root
                .set(snapshot.value),
          ),
          content: Text(
            'Basket is clear.',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) =>
            [LvSliverAppBar()],
        body: LvAnimatedList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
              flex: 1,
              child: LvGradientButton(
                text: 'Clear Basket',
                key: ValueKey('__btn1'),
                onPressed: () => this.removeAll(context),
              )),
          Flexible(
              flex: 1,
              child: LvGradientButton(
                text: 'Add',
                key: ValueKey('__btn2'),
                onPressed: () => this.add(context),
              )),
        ],
      ),
    );
  }
}
