import 'package:flutter/material.dart';

const _assetName = 'assets/images/groceries.png';

class LvSliverAppBar extends StatelessWidget {
  const LvSliverAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      elevation: 0.0,
      backgroundColor: Colors.grey.shade50,
      bottom: PreferredSize(
        // size of the app bar (above the preferred size widget).
        preferredSize: Size.fromHeight(30.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 46.0, bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Groceries',
                  textScaleFactor: 2.2,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                height: 30,
                child: Image(
                  fit: BoxFit.fitHeight,
                  image: AssetImage(_assetName),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
