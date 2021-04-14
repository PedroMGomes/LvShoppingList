import 'package:flutter/material.dart';
import 'package:lv_shop_list/models/lv_product.dart' show LvProduct;

/// Modal widget to add new item.
class LvAddItemModal extends StatefulWidget {
  LvAddItemModal({Key? key}) : super(key: key);

  @override
  _LvAddItemModalState createState() => _LvAddItemModalState();
}

class _LvAddItemModalState extends State<LvAddItemModal> {
  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController snController = TextEditingController(text: '');
  final FocusNode nameNode = FocusNode(canRequestFocus: true);
  final FocusNode snNode = FocusNode(canRequestFocus: false);

  /// init.
  @override
  void initState() {
    super.initState();
    this.nameNode.requestFocus();
  }

  /// dispose.
  @override
  void dispose() {
    this.nameController.dispose();
    this.snController.dispose();
    this.nameNode.unfocus();
    this.snNode.unfocus();
    super.dispose();
  }

  /// Add.
  void add(BuildContext context) {
    if (nameController.text.isEmpty) {
      Navigator.of(context).pop(null);
    } else {
      final LvProduct product =
          LvProduct(nameController.text, serialNumber: snController.text);
      Navigator.of(context).pop(product);
    }
  }

  /// build.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          maxLines: 1,
          cursorWidth: 1.0,
          focusNode: this.nameNode,
          controller: this.nameController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Name',
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: theme.primaryColor),
            ),
          ),
        ),
        TextField(
          maxLines: 1,
          cursorWidth: 1.0,
          focusNode: this.snNode,
          controller: this.snController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Ref',
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: theme.primaryColor),
            ),
          ),
          onSubmitted: (value) => this.add(context),
        ),
      ],
    );
  }
}
