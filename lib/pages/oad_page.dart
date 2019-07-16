import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

StreamController<NotifyInfo> notifyController = StreamController.broadcast();

class OadPage extends StatelessWidget {
  final BluetoothDevice device;

//  static StreamController<NotifyInfo> notifyController = StreamController.broadcast();
  List<BluetoothService> sService ;
  static List<BluetoothCharacteristic> sOadSerCharList;

  OadPage({Key key, this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream.fromFuture(device.discoverServices())
        .transform(_getOadService)
        .transform(_getCharacteristic)
        .transform(_listenCharNotifyAndSendHead)
        .listen((v){print("流已结束");});


    notifyController.stream.listen((list) {
      print("收到数据$list");
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("OAD 升级"),
      ),
      body: Column(
        children: <Widget>[
          // 一个开始按钮
//          RaisedButton(
//            child: Text("开始升级"),
////            onPressed: _onPress(),
//            onPressed: _onOadStartStream(),
//          ),
          StreamBuilder<bool>(
            stream: Stream.fromFuture(device.discoverServices())
                .transform(_getOadService)
                .transform(_getCharacteristic)
                .transform(_listenCharNotifyAndSendHead),
            initialData: false,
            builder: (context, snapshot) {
              final bool isPrepare = snapshot.data;
              return SingleChildScrollView(
                child: isPrepare
                    ? Text("正在准备...")
                    : RaisedButton(
                        child: Text("点击开始升级"),
                        onPressed: _startUpdate,
                      ),
              );
            },
          )
//          RaisedButton(
//            child: Text("点击读取文件"),
//            onPressed: _onReadFFC2Notif(chars),
//          )
          // todo 一个进度条
        ],
      ),
    );
  }

  /// OAD升级, 方案3, 使用Stream -===============================================
  _onOadStartStream() {
    print("点击了按钮。。。。");
//    s.listen((charList) {
    final List<int> head = [
      0x06,
      0x78,
      0xff,
      0xff,
      0x00,
      0x00,
      0xb4,
      0x30,
      0x45,
      0x45,
      0x45,
      0x45,
      0x00,
      0x00,
      0x01,
      0xff,
    ];
    // send
    device.discoverServices().then((service) {
      service.forEach((ser) {
        String keyUuid = ser.uuid.toString().substring(4, 8);
        if (keyUuid == "abf0" || keyUuid == "ffc0") {
          ser.characteristics.forEach((char) {
            String keyCharUuid = char.uuid.toString().substring(4, 8);
            if (keyCharUuid == "abf1" || keyCharUuid == "ffc1") {
              char.write(head);
            }
          });
        }
      });
    });
////    final List<int> data = [
////      6,
////      120,
////      255,
////      255,
////      0,
////      0,
////      180,
////      48,
////      69,
////      69,
////      69,
////      0,
////      0,
////      1,
////      255,
////    ]
//      charList[0].write(data);
//      print("oad_page ### 向ffc1 写入 元文件 第一行完毕");
//    }

//    );

//    if (characteristicList != null) characteristicList[0].write(data);
    print("执行完了，，，");
  }

  // 方案3, 第一个transformer, 从ServiceList中获取OAD Service
  final StreamTransformer _getOadService =
      StreamTransformer<List<BluetoothService>, BluetoothService>.fromHandlers(
          handleData: (serList, sink) {
    serList.forEach((ser) {
      print("oad_page ###服务的uuid:  ${ser.uuid.toString()}");
      if (ser.uuid.toString().substring(4, 8) == "ffc0" &&
          ser.uuid.toString().endsWith("0")) {
        print("oad_pag}e ###找到 Race 主服务:  ${ser.uuid.toString()}");

//        sOadService = ser;

        sink.add(ser);
      } else if (ser.uuid.toString().substring(4, 8) == "abf0") {
        /// debug ................................................................
        print("oad_page ###找到 RaceDB 主服务:  ${ser.uuid.toString()}");
//        sOadService = ser;
        sink.add(ser);
      }
    });
  });

  // 方案3, 第二个.., 从oad Service中 获取特征列表
  final StreamTransformer _getCharacteristic = StreamTransformer<
          BluetoothService, List<BluetoothCharacteristic>>.fromHandlers(
      handleData: (oadService, sink) {
    print("oad_page ###从oad Service中 获取特征列表");
    sink.add(oadService.characteristics);
  });

  // 方案3, 第三个, 打开 1, 2, 4 这几个特征的通知
  final StreamTransformer _listenCharNotifyAndSendHead =
      StreamTransformer<List<BluetoothCharacteristic>, bool>.fromHandlers(
          handleData: (charList, sink) {
    sOadSerCharList = charList;

    // 这里写一个 打开并监听 特征 的通知的方法, 如果出错, 考虑等监听出结果后再sink.add
    charList.forEach((char) {
      final String keyUuid = char.uuid.toString().substring(4, 8);
//      switch (char.uuid.toString().substring(7, 8)) {
      switch (keyUuid) {
        case "abf1":
        case "ffc1":
        case "ffc2":
        case "ffc3":
        case "ffc4":
        case "abf4":
          char.value.listen((d) {
            char.setNotifyValue(true); // 打开监听
            print("监听到 $keyUuid 的消息: $d");
            if (d.length > 0) {
              notifyController.sink
                  .add(NotifyInfo(charKeyUuid: keyUuid, notifyValue: d));
            }
//            notifyController.sink.add(NotifyInfo(charKeyUuid: keyUuid, notifyValue: d));
//            try {
//              sink.add(NotifyInfo(charKeyUuid: keyUuid, notifyValue: d));
//            } catch (e) {
//              print("添加新的Notify 出错了...." + e.toString());
//            }
          });
      }
    });

    sink.add(true);
  });

  // 开始升级
  void _startUpdate() {
    print("oad_page #### 开始发送头部数据");

    final List<int> head = [
      0x06,
      0x78,
      0xff,
      0xff,
      0x00,
      0x00,
      0xb4,
      0x30,
      0x45,
      0x45,
      0x45,
      0x45,
      0x00,
      0x00,
      0x01,
      0xff,
    ];
    assert(sOadSerCharList.length > 0);

    sOadSerCharList[0].write(head, withoutResponse: true);
  }
}

class NotifyInfo {
  String charKeyUuid;
  List<int> notifyValue;

  NotifyInfo({this.charKeyUuid, this.notifyValue});

  @override
  toString() {
    return "Key UUID : $charKeyUuid, Notify: $notifyValue";
  }
}
