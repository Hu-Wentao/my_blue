import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:my_blue/widgets/characteristic_tile.dart';
import 'package:my_blue/widgets/descriptor_tile.dart';
import 'package:my_blue/widgets/service_tile.dart';

/// 设备详情页
class DeviceScreen extends StatelessWidget {
  final BluetoothDevice device;

  const DeviceScreen({Key key, this.device}) : super(key: key);

  /// 第一行, 表示设备状态的 tile
  Widget _buildDeviceStateTileTrailing(BuildContext context) {
    return StreamBuilder<bool>(
      stream: device.isDiscoveringServices,
      initialData: false,
      builder: (c, snapshot) => IndexedStack(
        index: snapshot.data ? 1 : 0,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
            ),
            onPressed: () => device.discoverServices(),
          ),
          IconButton(
            icon: SizedBox(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.grey),
              ),
              width: 18.0,
              height: 18.0,
            ),
            onPressed: null,
          )
        ],
      ),
    );
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (service) => ServiceTile(
            service: service,
            characteristicTiles: service.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    // TODO 读取数据 测试函数
                    /// 测试后, 从设备读取了一个数组
                    onReadPressed: () => c.read().then((onValue) {
                      onValue.forEach((e) {
                        print("获取List元素: $e");
                      });
                    }),
                    //写入数据
                    /// ================== 发送数据 ===========
                    onWritePressed: () => c.write([66, 67, 48, 49]),
                    onNotificationPressed: () {
//                      c.read().then((v)=>print("测试可能读取到: $v"));
                      c.setNotifyValue(!c.isNotifying);

                      //todo 展示. 或使用.....
                      c.value.listen((v)=>print("######====== 接受到数据 =====#######$v"));
                    },
                    //todo 描述...
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            // 映射为
                            // 描述tile
                            descriptor: d,
                            onReadPressed: () => d.read(), // 描述读取??
                            onWritePressed: () {
                              return d.write([65, 66]);
                            }, // 描述写入??
                          ),
                        )
                        .toList(),
                  ),
                )

                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 第一行, 展示蓝牙设备状态
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(
                        Icons.bluetooth_connected,
                        color: Colors.lightBlue,
                      )
                    : Icon(Icons.bluetooth_disabled, color: Colors.grey),
                title: Text('当前状态: ${snapshot.data.toString().split('.')[1]}'),
                subtitle: Text('${device.id}'),
                trailing: _buildDeviceStateTileTrailing(context), //
              ),
            ),
            // 第二行, 展示蓝牙设备服务, 特性, 描述
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data),
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(device.name),

      /// 获取设备名称
      actions: <Widget>[
        StreamBuilder<BluetoothDeviceState>(
          stream: device.state,
          initialData: BluetoothDeviceState.connecting,
          builder: (c, snapshot) {
            VoidCallback onPressed;
            String text;
            switch (snapshot.data) {
              case BluetoothDeviceState.connected:

                /// 连接设备
                onPressed = () => device.disconnect();
                text = '断开';
                break;
              case BluetoothDeviceState.disconnected:

                /// 断开设备
                onPressed = () => device.connect();
                text = '连接';
                break;
              default:
                onPressed = null;
                text = snapshot.data
                    .toString()
                    .substring(21)
                    .toUpperCase(); // 默认的蓝牙状态
                break;
            }
            return FlatButton(

                ///########################################### appBar 上的按钮
                onPressed: onPressed,
                child: Text(
                  text,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .button
                      .copyWith(color: Colors.white),
                ));
          },
        )
      ],
    );
  }
}
