import 'package:flutter/material.dart';

class LvGradientButton extends StatelessWidget {
  const LvGradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final borderRadius = BorderRadius.circular(42.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 8.0,
        shadowColor: primaryColor.withOpacity(0.6),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(42.0)),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, Color(0xFF7c99ff)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: borderRadius,
          ),
          child: InkWell(
            borderRadius: borderRadius,
            child: Container(
              height: 60,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 42.0),
              child: FittedBox(
                alignment: Alignment.center,
                child: Text(
                  this.text,
                  textScaleFactor: 1.1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onTap: () => this.onPressed(),
          ),
        ),
      ),
    );
  }
}
