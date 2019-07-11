import 'package:flutter/material.dart';

/// 帶一条线的标题
class TextDivider extends StatelessWidget {
  final String title;
  final List<double> padLTRB;

  TextDivider(
    this.title, {
    Key key,
    this.padLTRB: const [16.0, 8.0, 16.0, 8.0],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          padLTRB[0], padLTRB[1], padLTRB[2], padLTRB[3]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            this.title,
            textAlign: TextAlign.start,
          ),
          Divider()
        ],
      ),
    );
  }
}
