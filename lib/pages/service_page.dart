
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:my_blue/widgets/characteristic_tile.dart';
import 'package:my_blue/widgets/none_border_color_expansion_tile.dart';
import 'package:my_blue/widgets/radius_container_widget.dart';

class ServiceAbf0Page extends StatelessWidget{
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceAbf0Page({Key key, this.service, this.characteristicTiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadiusContainer(
      child: NoneBorderColorExpansionTile(

      ),
    );
  }

}