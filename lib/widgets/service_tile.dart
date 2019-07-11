import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'characteristic_tile.dart';
import 'none_border_color_expansion_tile.dart';
import 'radius_container_widget.dart';

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile({Key key, this.service, this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.length > 0) {
      return RadiusContainer(
        child: NoneBorderColorExpansionTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Service: 0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
//                  style: Theme.of(context)
//                      .textTheme
//                      .body1
//                      .copyWith(color: Theme.of(context).textTheme.caption.color))
              )
            ],
          ),
          children: characteristicTiles,
        ),
      );
    } else {
      return ListTile(
        title: Text('无特征 Service'),
        subtitle:
        Text('0x${service.uuid.toString().substring(4, 8).toUpperCase()}'),
      );
    }
  }
}