import 'package:flutter/material.dart';

class RadiusButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;

  final Color textColor;
  final Color bgColor;

  final double sizeHeight;
  final double sizeWidth;
  final double borderRadius;
  RadiusButton(
      {Key key,
      @required this.child,
      this.onPressed,
      this.textColor: Colors.white,
      this.bgColor: Colors.grey,
      this.sizeHeight,
      this.sizeWidth: 32,
      this.borderRadius: 12,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: sizeWidth,

        child: FlatButton(
          child: child,
          textColor: textColor,
          onPressed: onPressed,
        ),
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      color: bgColor,
    );
  }
}
