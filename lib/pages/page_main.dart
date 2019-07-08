import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    // 表示当前蓝牙状态
//    BluetoothState _bluetoothState = BluetoothState.STATE_UNKNOWN;

    // todo 后台信息收集任务...
    // BackgroundCollectingTask _collectingTask;   ///

    return Scaffold(
      appBar: AppBar(
        title: Text("蓝牙功能"),
      ),
//      body: SwitchListTile(value: , onChanged: null),
      body: Container(
        child: ListView(
          children: <Widget>[
            /// 列表
            ListTile(
              title: RaisedButton(child: Text("开始"), onPressed: () {

                print("lalal");

              }),
            )
          ],
        ),
      ),
    );
  }
}
