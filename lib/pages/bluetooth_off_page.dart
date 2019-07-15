import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

///
/// 蓝牙关闭时的页面
/// //todo 为蓝牙图标添加 点击事件, 以快速开启蓝牙
class BluetoothOffPage extends StatelessWidget {
  final BluetoothState bleState;

  const BluetoothOffPage({Key key, this.bleState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
//      appBar: AppBar(
//        title: Text("aaa"), // todo appbar 考虑用于显示当前蓝牙状态
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