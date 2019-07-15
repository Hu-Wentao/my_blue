import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

///
///
class OadPage extends StatelessWidget {
  final BluetoothDevice device;

//  List<BluetoothCharacteristic> charList = new List(4);

  OadPage({Key key, this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    List<BluetoothCharacteristic> chars = new List(4);

    return Scaffold(
      appBar: AppBar(
        title: Text("OAD 升级"),
      ),
      body: Column(
        children: <Widget>[
          // 一个开始按钮
          RaisedButton(
            child: Text("开始升级"),
            onPressed: _onOadStartStream,
//            onPressed: chars = _onOadStartFuture(),
          ),
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

    Stream<List<BluetoothService>> serviceStream =
        Stream.fromFuture(device.discoverServices());

//    Stream<List<BluetoothCharacteristic>> charList =
    serviceStream

//    Stream.fromFuture(device.discoverServices())
        .transform(_getOadService)
        .transform(_getCharacteristic)
        .transform(_openCharNotify)
        .listen((charList) {
//      for (int i in [0, 1, 3]) {
//        (charList[i] as BluetoothCharacteristic).value.listen((v) {
//          print("### FFC${i + 1} 监听到通知$v");
//        });
//      }

      final List<int> data = [
      0x06, 0x78, 0xff,0xff,
      0x00, 0x00, 0xb4, 0x30,
      0x45,0x45,0x45,0x45,
      0x00,0x00, 0x01, 0xff,
    ];
//    final List<int> data = [
//      6,
//      120,
//      255,
//      255,
//      0,
//      0,
//      180,
//      48,
//      69,
//      69,
//      69,
//      0,
//      0,
//      1,
//      255,
//    ]
      charList[0].write(data);
      print("oad_page ### 向ffc1 写入 元文件 第一行完毕");
    });

//    charList.
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
        print("oad_page ###找到主服务:  ${ser.uuid.toString()}");
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
  final StreamTransformer _openCharNotify = StreamTransformer<
      List<BluetoothCharacteristic>,
      List<BluetoothCharacteristic>>.fromHandlers(handleData: (charList, sink) {
    // 这里写一个 打开并监听 特征 的通知的方法, 如果出错, 考虑等监听出结果后再sink.add

    charList.forEach((char) {
      String s = char.uuid.toString().substring(7, 8);
      switch (s) {
        case "1":
        case "2":
        case "4":
          char.value.listen((d) {
            print("监听到 FFC$s 的消息: $d");
          });
      }
    });

//    final List<int> data = [1, 3, 55, 22];
////      0x06, 0x78, 0xff,0xff,
////      0x00, 0x00, 0xb4, 0x30,
////      0x45,0x45,0x45,0x45,
////      0x00,0x00, 0x01, 0xff,
////    ];
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
//    charList[0].write(data);
//    print("oad_page ### 向ffc1 写入 元文件 第一行完毕");

    sink.add(charList);
  });

  /// oad升级 方案2================================================================
  _onOadStartFuture() {
    BluetoothService mainService;
    List<BluetoothCharacteristic> charList = new List(4);

    device.discoverServices().then((serviceList) {
      serviceList.forEach((ser) {
        //todo del
        print("oad_page ###服务的uuid:  ${ser.uuid.toString()}");
        if (ser.uuid.toString().substring(4, 8) == "ffc0" &&
            ser.uuid.toString().endsWith("0")) {
          print("oad_page ###找到主服务:  ${ser.uuid.toString()}");
          mainService = ser;
        }
      });
      return mainService;
    }).then((mainService) {
      // 读取并保存通知, ffc1, ffc2, ffc4 ==============================K
      // todo del
      int i = 0;
      mainService.characteristics.forEach((cha) {
        print("oad_page ### 特征 的uuid:  ${cha.uuid.toString()}");
        charList[i++] = cha;
      });
      return charList;
    }).then((charList) {
      print("oad_page ### 打开1, 2, 4 号通知");

      for (int i in [0, 1, 3]) {
        charList[i].setNotifyValue(true);
      }
      print("oad_page ### 打开1, 2, 4 号通知 完毕");
      return charList;
    }).then((charList) {
      print("oad_page ### 向ffc1 写入 元文件 第一行");

      charList[0].write([
        6,
        120,
        255,
        255,
        0,
        0,
        180,
        48,
        69,
        69,
        69,
        0,
        0,
        1,
        255,
      ]);
      print("oad_page ### 向ffc1 写入 元文件 第一行完毕");
      return charList;
    }).then((charList) {
      charList[1].value.listen((notify) {
        print("oad_page ########## 收到通知: $notify");
      });
    })
//        .then((charList){
//      return Future.delayed(Duration(seconds: 1)).then((v)=>v);
//      return charList;
//    })
        ;
  }

  // OAD升级 -- 方案1,
  _onOadStart() async {
    // 打开服务 ffc0 ================================================
    //// 获取服务列表 =================================================
    List<BluetoothService> serviceList = await device.discoverServices();
    BluetoothService mainService;
    serviceList.forEach((ser) {
      //todo del
      print("oad_page ###服务的uuid:  ${ser.uuid.toString()}");
      if (ser.uuid.toString().substring(4, 8) == "ffc0" &&
          ser.uuid.toString().endsWith("0")) {
        print("oad_page ###找到主服务:  ${ser.uuid.toString()}");
        mainService = ser;
      }
    });
    // 读取并保存通知, ffc1, ffc2, ffc4 ==============================K
    List<BluetoothCharacteristic> charList = new List(4);
    // todo del
    int i = 0;
    mainService.characteristics.forEach((cha) {
      print("oad_page ### 特征 的uuid:  ${cha.uuid.toString()}");
      charList[i++] = cha;
    });

    //  ====================================== 22:28:15.312
    print("oad_page ### 打开1, 2, 4 号通知");

    for (int i in [0, 1, 3]) {
      charList[i].setNotifyValue(true);
    }
    print("oad_page ### 打开1, 2, 4 号通知 完毕");

    print("oad_page ### 向ffc1 写入 元文件 第一行");

    charList[0].write([
      6,
      120,
      255,
      255,
      0,
      0,
      180,
      48,
      69,
      69,
      69,
      69,
      0,
      0,
      1,
      255,
    ], withoutResponse: true);
    print("oad_page ### 向ffc1 写入 元文件 第一行完毕");

    print("oad_page ### 开始读取");
    charList[1].read().then((v) {
      v.forEach((v) => print("读取的内容### $v"));
    });
    print("oad_page ### 读取完毕");
  }

  _onReadFFC2Notif(List<BluetoothCharacteristic> charList) {
    print("oad_page ### 开始读取");
    charList[1].read().then((v) {
      v.forEach((v) => print("读取的内容### $v"));
    });
    print("oad_page ### 读取完毕");
  }
}
