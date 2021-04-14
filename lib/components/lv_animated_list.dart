import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:lv_shop_list/components/lv_item.dart';
import 'package:lv_shop_list/models/lv_product.dart';
import 'package:lv_shop_list/providers/lv_firebase_provider.dart'
    show LvFirebaseProvider;
import 'package:provider/provider.dart';

/// Wrapper to `FirebaseAnimatedList`.
class LvAnimatedList extends StatelessWidget {
  const LvAnimatedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LvFirebaseProvider>(
      builder: (_, provider, __) => FirebaseAnimatedList(
        padding: const EdgeInsets.only(bottom: 100),
        query: provider.database.reference().root(),
        itemBuilder: (context, DataSnapshot item, animation, index) =>
            FadeTransition(
          opacity: animation,
          child: LvItem(
            key: ValueKey(item.key),
            firebaseItemKey: item.key,
            item: LvProduct.fromJson(item.value),
          ),
        ),
      ),
    );
  }
}
