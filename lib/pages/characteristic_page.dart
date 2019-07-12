
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:my_blue/widgets/none_border_color_expansion_tile.dart';
import 'package:my_blue/widgets/radius_container_widget.dart';

class CharacteristicPage extends StatelessWidget{
  final BluetoothService service;

  const CharacteristicPage({Key key, this.service, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadiusContainer(
      child: NoneBorderColorExpansionTile(
        children: <Widget>[

        ],
      ),
    );
  }

}