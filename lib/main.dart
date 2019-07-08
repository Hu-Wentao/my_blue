import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:my_blue/Screen/screen_bluetooth_off.dart';
import 'package:my_blue/Screen/screen_search_device.dart';

// 考虑使用 BLoC 和 RxDart 重构
void main() => runApp(MaterialApp(
      title: "bluetooth demo",
      theme: ThemeData(primaryColor: Colors.lightBlue),
      home: BlueApp(),
    ));

class BlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (buildContext, asyncSnapshot) {
          final state = asyncSnapshot.data;
          if (state == BluetoothState.on) {
            return SearchDeviceScreen();
          }
          return BluetoothOffScreen();
        });
  }
}
