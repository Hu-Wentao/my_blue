import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:my_blue/widgets/none_border_color_expansion_tile.dart';
import 'package:my_blue/widgets/radius_container_widget.dart';
import 'package:permission_handler/permission_handler.dart';

StreamController<NotifyInfo> notifyController = StreamController.broadcast();

//NotifyInfo temp;

class NewOadPage extends StatelessWidget {
  final BluetoothDevice device;

//  AssetBundle bundle;
  Future binFile;

  NewOadPage({Key key, this.device}) : super(key: key) {
    device.discoverServices();
//    bundle = rootBundle;
    binFile = _getBin();

    /////////////////////////////////////////////////////////////////////////////
    NotifyInfo temp; // 保存上一次的NotifyInfo, 防止收到两个一样的
    notifyController.stream.where((n) {
      if (n.notifyValue.isEmpty) return false;
      bool canShow = temp != n;
      temp = n;
      return canShow;
    }).listen((notifyInfo) {
      print(
          "# # # 收到回传消息: $notifyInfo, ||| {c.uuid.toString()} ============================================");
      switch (notifyInfo.charKeyUuid) {
        case "abf1":
        case "ffc1":
          break;
        case "ffc2":
          break;
        case "ffc4":
          break;
      }
    });
  }

  _getBin() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    await PermissionHandler()
        .shouldShowRequestPermissionRationale(PermissionGroup.storage);
    return rootBundle.load("assset/test.bin");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("固件升级"),
      ),
//      appBar: AppBar(title: Text("固件升级"), actions: _buildActionBtn(context),),
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
              builder: (context, snapshot) {
                return Column(
                  children: _buildServiceTile(snapshot.data),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildServiceTile(List<BluetoothService> serList) {
    return serList.where((s) {
      final String keyUuid = s.uuid.toString().substring(4, 8);
      return (keyUuid == "abf0" || keyUuid == "ffc0");
    }).map(
      (s) {
        return ServiceTile(
          service: s,
          characteristicTiles: s.characteristics.where((c) {
            final String keyCharUuid = c.uuid.toString().substring(4, 8);
            return [
                  "abf1",
                  "ffc1",
                  "ffc2",
                  "ffc4",
                  "abf4",
                ].indexOf(keyCharUuid) >=
                0;
          }).map((c) {
            return CharacteristicTile(
              characteristic: c,
              onReadPressed: () => c.read(),
              onWritePressed: _logic(c),

              /// 写入 数据
              onNotificationPressed: () {
                print("当前char: ${c.uuid.toString().substring(4,8)} 通知是否打开: ${c.isNotifying}");
                c.setNotifyValue(!c.isNotifying);
              },
            );
          }).toList(),
        );
      },
    ).toList();
  }

  _logic(BluetoothCharacteristic c) {
//  _logic() {
    print("# # # logic 方法被执行, ${c.uuid.toString()}");
  }

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
}

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
          initiallyExpanded: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Service: 0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
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

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;

//  final List<DescriptorTile> descriptorTiles;
  final TextField sendBox; // 发送消息输入框
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  final VoidCallback onNotificationPressed;

  CharacteristicTile(
      {Key key,
      this.characteristic,
//        this.descriptorTiles,
      this.onReadPressed,
      this.onWritePressed,
      this.onNotificationPressed,
      this.sendBox})
      : super(key: key) {
    final String k = characteristic.uuid.toString().substring(4, 8);
    if ([
      "abf1",
      "ffc1",
      "ffc2",
      "ffc4",
      "abf4",
    ].contains(k)) {
      if (!characteristic.isNotifying) {
        print("当前正在开启 ${characteristic.uuid} 的通知");
        characteristic.setNotifyValue(true);
//        Future.delayed(const Duration(seconds: 1))
//            .then((v) => characteristic.setNotifyValue(true));
      }
      print("特征$k的通知打开了###");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value, // 读取结果
      initialData: characteristic.lastValue, // 存放上一次的结果
      builder: (c, snapshot) {
        final keyUuid =
            characteristic.uuid.toString().toUpperCase().substring(4, 8);
        final value = snapshot.data;
//        print("构建方法被执行了.... 会添加新的value....");
        notifyController.sink.add(NotifyInfo(
            char: characteristic, charKeyUuid: keyUuid, notifyValue: value));

        /// ------------------------------- 加入流
        return NoneBorderColorExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('特征: 0x$keyUuid',
                    style: Theme.of(context).textTheme.body1.copyWith(
                        color: Theme.of(context).textTheme.caption.color)),
              ],
            ),
            subtitle: Text(value.toString()),
            contentPadding: EdgeInsets.all(0.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Theme.of(context).iconTheme.color.withOpacity(0.5),
                ),
                onPressed: onReadPressed,
              ),
              IconButton(
                icon: Icon(Icons.file_upload,
                    color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
                onPressed: onWritePressed,
              ),
              IconButton(
                icon: Icon(
                    characteristic.isNotifying
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    color: characteristic.isNotifying
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).iconTheme.color.withOpacity(0.5)),
                onPressed: onNotificationPressed,
              ),
            ],
          ),
        );
      },
    );
  }
}

class NotifyInfo {
  String charKeyUuid;
  List<int> notifyValue;
  BluetoothCharacteristic char;

  NotifyInfo({this.char, this.charKeyUuid, this.notifyValue});

  @override
  toString() {
    return "From: ${char.uuid.toString()} Key UUID : $charKeyUuid, Notify: $notifyValue";
  }

//  bool operator+(NotifyInfo ps){
//    if (this.charKeyUuid == ps.charKeyUuid) {
//      return true;
//    }
//    return false;
//  }
//  bool operator == (const NotifyInfo info){
//    return false;
//  }
}
