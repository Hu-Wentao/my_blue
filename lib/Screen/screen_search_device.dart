import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:my_blue/widgets/widgets.dart';

///
/// 查找蓝牙设备
///
class SearchDeviceScreen extends StatelessWidget {
  // 蓝牙扫描的时长
  final Duration scanTimeout = Duration(seconds: 4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "搜索设备",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          actions: <Widget>[
            StreamBuilder<bool>(
              stream: FlutterBlue.instance.isScanning,
              initialData: false,
              builder: (buildContext, asyncSnapshot) {
                if (asyncSnapshot.data) {
                  return FlatButton(
                    // todo 制作一个  表示正在搜索蓝牙设备的动画,
                    // 方案1, 放一个刷新icon, 点击即旋转, 表示正在搜索, 动画结束, 表示搜索完毕
                    // 方案2, 放一个正在搜索蓝牙icon, 点击后, 表示信号的弧形慢慢增多, 然后
                    child: Icon(
                      Icons.stop,
                      color: Colors.red,
                    ),
                    onPressed: () => FlutterBlue.instance.stopScan(),
                  );
                } else {
                  return FlatButton(
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        FlutterBlue.instance.startScan(timeout: scanTimeout),
                  );
                }
              },
            )
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () =>
                FlutterBlue.instance.startScan(timeout: scanTimeout),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // todo 拆分
                  StreamBuilder<List<BluetoothDevice>>(
                    stream: Stream.periodic(Duration(seconds: 2))
                        .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                    initialData: [],
                    builder: (buildContext, asyncSnapshot) => Column(
                          children: asyncSnapshot.data
                              .map((data) => FlatButton(
                                    child: ListTile(
                                      title: Text(data.name),
                                      subtitle: Text(data.id.toString()),
//                                    trailing: ,
                                    ),
                                  ))
                              .toList(),
                        ),
                  ),
                  Divider(),
                  // todo 拆分到page包
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBlue.instance.scanResults,
                    initialData: [],
                    builder: (buildContext, asyncSnapshot) => Column(
                        children: asyncSnapshot.data
                            .map((data) => ScanResultTile(
                                result: data,
                                onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                        data.device.connect();
                                        return DeviceScreen(
                                            device: data.device);
                                      }),
                                    )))
                            .toList()),
                  )
                ],
              ),
            )));
  }
}

class DeviceScreen extends StatelessWidget {
  final BluetoothDevice device;
  const DeviceScreen({Key key, this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("test"),
      ),
    );
  }
}
