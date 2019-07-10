import 'package:flutter/material.dart';

class RadiusButton extends StatelessWidget{
  final Function onPressed;
  final Widget child;
  RadiusButton({@required this.child, @required this.onPressed, Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 32,
        child: FlatButton(
          child: child,
//          color: Colors.black,
          textColor: Colors.white,
          onPressed: onPressed,
        ),
      ),
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey,
    );
  }

}