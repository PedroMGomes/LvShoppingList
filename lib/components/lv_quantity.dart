import 'package:flutter/material.dart';
import 'package:lv_shop_list/providers/lv_firebase_provider.dart'
    show LvFirebaseProvider;
import 'package:provider/provider.dart';

/// Has animated effect when it builds (everytime the quantity value is updated)
class LvQuantity extends StatefulWidget {
  LvQuantity({
    Key? key,
    required this.quantity,
    required this.firebaseKey,
  }) : super(key: key);

  final int quantity;
  final String firebaseKey;

  @override
  _LvQuantityState createState() => _LvQuantityState();
}

class _LvQuantityState extends State<LvQuantity>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  /// Toggle item state.
  void toggleState(BuildContext context, String firebaseKey) async {
    if (widget.quantity < 1) {
      // enable item by setting the quantity to 1.
      await context.read<LvFirebaseProvider>().update(firebaseKey, 1);
    } else {
      // disable item by settings the quantity to 0.
      await context.read<LvFirebaseProvider>().update(firebaseKey, 0);
    }
  }

  /// init.
  @override
  void initState() {
    super.initState();
    this._controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 64));
    this._animation =
        Tween<double>(begin: 1.0, end: 1.5).animate(this._controller);
    this._controller.addListener(() {
      if (this._controller.isCompleted) {
        this._controller.reverse();
      }
    });
    // starts animation.
    this._controller.forward();
  }

  /// dispose.
  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  /// build
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.grey.shade100;
    final leadingTextStyle = Theme.of(context).textTheme.headline6;
    final outerBorderRadius = BorderRadius.circular(22.0);
    final borderSide = BorderSide(width: 1.0, color: Colors.grey.shade200);
    final outerBorder = RoundedRectangleBorder(
        borderRadius: outerBorderRadius, side: borderSide);
    return GestureDetector(
      onTap: () => this.toggleState(context, widget.firebaseKey),
      child: Material(
        shape: outerBorder,
        color: backgroundColor,
        child: Container(
          width: 55,
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: this._animation,
            alignment: Alignment.center,
            child: Text(
              widget.quantity.toString(),
              style: leadingTextStyle?.copyWith(
                fontWeight: FontWeight.bold,
                color: (widget.quantity < 1) ? Colors.grey : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
