import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

///
///
class OadPage extends StatelessWidget {
  final BluetoothDevice device;
  OadPage({Key key, this.device}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Stream<List<BluetoothCharacteristic>> s =
        Stream.fromFuture(device.discoverServices())
            .transform(_getOadService)
            .transform(_getCharacteristic)
            .transform(_openAndListenCharNotify)
            .asBroadcastStream();

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
//            onPressed: _onOadStartStream(s),
//          ),
//          StreamBuilder<List<BluetoothCharacteristic>>(
//            stream: s,
//            builder: (context, snapshot) {
//              final List<BluetoothCharacteristic> charList = snapshot.data;
//              return
//                SingleChildScrollView(
//                child:Text(),
//                );
//            },
//          )
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
  _onOadStartStream(Stream s) {
    print("点击了按钮。。。。");
//    s.listen((charList) {
    final List<int> data = [
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
        print("oad_page ###找到 Race 主服务:  ${ser.uuid.toString()}");
        sink.add(ser);
      } else if (ser.uuid.toString().substring(4, 8) == "abf0") {
        /// debug ................................................................
        print("oad_page ###找到 RaceDB 主服务:  ${ser.uuid.toString()}");
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
  final StreamTransformer _openAndListenCharNotify = StreamTransformer<
      List<BluetoothCharacteristic>,
      List<BluetoothCharacteristic>>.fromHandlers(handleData: (charList, sink) {
    // 这里写一个 打开并监听 特征 的通知的方法, 如果出错, 考虑等监听出结果后再sink.add
    charList.forEach((char) {
      switch (char.uuid.toString().substring(7, 8)) {
        case "1":
        case "2":
        case "4":
          char.value.listen((d) {
            print("监听到 ${char.uuid.toString().substring(4, 8)} 的消息: $d");
          });
      }
    });
    sink.add(charList);
  });
}

class CharListen{
  String charUuid;
  String notifyInfo;
}
