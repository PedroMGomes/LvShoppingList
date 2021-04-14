import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lv_shop_list/utils/lv_logger.dart';
import 'package:lv_shop_list/providers/lv_firebase_provider.dart'
    show LvFirebaseProvider;
import 'package:lv_shop_list/components/lv_quantity.dart' show LvQuantity;
import 'package:lv_shop_list/models/lv_product.dart' show LvProduct;

/// Widget for [LvProduct].
class LvItem extends StatelessWidget {
  LvItem({Key? key, required this.firebaseItemKey, required this.item})
      : super(key: key);

  final String firebaseItemKey;
  final LvProduct item;

  /// adds 1 to the item quantity
  void addUnit(BuildContext context) async {
    try {
      await context
          .read<LvFirebaseProvider>()
          .update(this.firebaseItemKey, this.item.quantity + 1);
    } catch (err) {
      logger.w('$err');
    }
  }

  /// decreases 1 from the item quantity.
  void removeUnit(BuildContext context) async {
    if (this.item.quantity > 0) {
      try {
        await context
            .read<LvFirebaseProvider>()
            .update(this.firebaseItemKey, this.item.quantity - 1);
      } catch (err) {
        logger.w('$err');
      }
    }
  }

  /// removes item from the List of groceries.
  Future<void> removeItem(BuildContext context) async {
    // removes current snackbar, if any.
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    try {
      await context.read<LvFirebaseProvider>().remove(firebaseItemKey);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${item.name} has been removed.",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white),
          ),
        ),
      );
    } catch (err) {
      logger.w('$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = (this.item.quantity < 1) ? Colors.grey : Colors.black;
    return ListTile(
      tileColor: (this.item.quantity < 1) ? textColor.withOpacity(0.2) : null,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            this.item.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
      subtitle: Text('Ref: ${this.item.serialNumber}'),
      leading: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: LvQuantity(
          key: ValueKey('$firebaseItemKey + ${item.quantity}'),
          quantity: item.quantity,
          firebaseKey: firebaseItemKey,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LvItemButton(
              icon: Icons.clear,
              onPressed: () async => await this.removeItem(context)),
          const SizedBox(width: 15.0),
          _LvItemButton(
              icon: Icons.remove, onPressed: () => this.removeUnit(context)),
          const SizedBox(width: 15.0),
          _LvItemButton(icon: Icons.add, onPressed: () => this.addUnit(context))
        ],
      ),
    );
  }
}

/// Edit the item quantity.
class _LvItemButton extends StatelessWidget {
  const _LvItemButton({Key? key, required this.onPressed, required this.icon})
      : super(key: key);

  final Function onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final innerBorderRadius = BorderRadius.circular(12.0);
    final borderSide = BorderSide(width: 1.0, color: Colors.grey.shade200);
    final innerBorder = RoundedRectangleBorder(
        borderRadius: innerBorderRadius, side: borderSide);
    return Material(
      shape: innerBorder,
      color: Colors.white,
      child: InkWell(
        borderRadius: innerBorderRadius,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(this.icon, color: Colors.grey.shade400),
        ),
        onTap: () => this.onPressed(),
      ),
    );
  }
}
