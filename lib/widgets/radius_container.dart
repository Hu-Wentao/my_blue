import 'package:flutter/material.dart';

class RadiusContainer extends StatelessWidget {
  final Widget child;

  RadiusContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: child,
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Colors.grey,
        elevation: 4,
      ),
    );
  }
}
