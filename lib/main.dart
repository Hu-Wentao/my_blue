import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_blue/blocs/bloc_provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(MaterialApp(
      title: "sss",
      theme: ThemeData(primaryColor: Colors.lightBlue),
      home: BlueApp(),
    ));

class BlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "使用BloC的bluetooth test",
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: StreamBuilder<BluetoothState>(
            stream: FlutterBlue.instance.state,
            initialData: BluetoothState.unknown,
            builder: (buildContext, asyncSnapshot) {
              final state = asyncSnapshot.data;
              if (state == BluetoothState.on) {
                return FindDevicesScreen();
              }
              return BleOffScreen();
            }));
  }
}

///
/// 蓝牙关闭时的页面
/// //todo 为蓝牙图标添加 点击事件, 以快速开启蓝牙
class BleOffScreen extends StatelessWidget {
  final BluetoothState bleState;

  const BleOffScreen({Key key, this.bleState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
//      appBar: AppBar(
//        title: Text("aaa"), // todo appbar 考虑显示当前蓝牙状态
//      ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.bluetooth_disabled,
                  size: 60,
                  color: Colors.white,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "请开启蓝牙",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("寻找设备"),
      ),
      body: Center(
        child: Text("蓝牙已开启"),
      ),
    );
  }
}
