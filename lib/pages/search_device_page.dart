import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:my_blue/widgets/radius_container_widget.dart';
import 'package:my_blue/widgets/radius_text_botton_widget.dart';
import 'package:my_blue/widgets/scan_result_tile.dart';
import 'package:my_blue/widgets/text_divider_widget.dart';

import 'device_info_page.dart';
import 'oad_page.dart';

///
/// 查找蓝牙设备
///
class SearchDevicePage extends StatelessWidget {
  // 蓝牙扫描的时长
  final Duration scanTimeout = const Duration(seconds: 4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "搜索设备", // todo 考虑在这里做一个动画。。。。可能会影响性能
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          actions: _buildActions(),
        ),
        body: RefreshIndicator(
          onRefresh: () => FlutterBlue.instance.startScan(timeout: scanTimeout),
          child: SingleChildScrollView(child: _buildBody(context)),
        ));
  }

  ///
  /// 构建AppBar上的Actions
  ///
  _buildActions() {
    return <Widget>[
      // ODA 模式
//      StreamBuilder<bool>(
//
//    ),

      // 搜索设备 按钮
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
    ];
  }

  _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        TextDivider(
          "已配对设备",
          padLTRB: const [16.0, 16.0, 16.0, 8.0],
        ),
        StreamBuilder<List<BluetoothDevice>>(
          stream: Stream.periodic(Duration(seconds: 2))
              .asyncMap((_) => FlutterBlue.instance.connectedDevices),
          initialData: [],
          builder: (buildContext, asyncSnapshot) => Column(
            children: asyncSnapshot.data.map((asyncDevice) {
              /// 是否开启OAD 模式(进入OAD页面)
              final bool isOad = asyncDevice.name.startsWith("Race");
              return RadiusContainer(
                  child: ListTile(
                leading: isOad
                    ? StreamBuilder<BluetoothDeviceState>(
                        stream: asyncDevice.state,
                        initialData: BluetoothDeviceState.disconnected,
                        builder: (c, snapshot) {
                          if (snapshot.data == BluetoothDeviceState.connected) {
                            return RadiusButton(
                              sizeWidth: 64,
                              sizeHeight: 36,
                              child: Text("打开"),
                              onPressed: _goToPage(!isOad, context, asyncDevice),
                            );
                          }
                          return RadiusButton(
                              child: Text(snapshot.data.toString()));
                        },
                      ):null,
                title: Text(asyncDevice.name),
                subtitle: Text(asyncDevice.id.toString()),
                trailing: StreamBuilder<BluetoothDeviceState>(
                  stream: asyncDevice.state,
                  initialData: BluetoothDeviceState.disconnected,
                  builder: (c, snapshot) {
                    if (snapshot.data == BluetoothDeviceState.connected) {
                      return RadiusButton(
                        sizeWidth: 64,
                        sizeHeight: 36,
                        child: Text(isOad ? "OAD" : "打开"),
                        onPressed: _goToPage(isOad, context, asyncDevice),
                      );
                    }
                    return RadiusButton(child: Text(snapshot.data.toString()));
                  },
                ),
              ));
            }).toList(),
          ),
        ),
        TextDivider("扫描结果"),
        StreamBuilder<List<ScanResult>>(
          stream: FlutterBlue.instance.scanResults,
          initialData: [],
          builder: (buildContext, asyncSnapshot) => Column(
              children: asyncSnapshot.data
                  .map((data) => RadiusContainer(
                        child: ScanResultTile(
                            result: data,
                            onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    data.device.connect();
                                    return DeviceInfoPage(device: data.device);
                                  }),
                                )),
                      ))
                  .toList()),
        )
      ],
    );
  }

  _goToPage(bool isOAD, BuildContext context, BluetoothDevice device) {
    return () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            // 切换页面
            isOAD ? OadPage(device: device) : DeviceInfoPage(device: device)));
  }
}
