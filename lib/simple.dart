import 'package:flutter_blue/flutter_blue.dart';

func(){
  // 获取实例
  FlutterBlue flutterBlue = FlutterBlue.instance;



  //寻找蓝牙设备
  BluetoothDevice device;   // flutter blue 包中的类 ,

  /// Start scanning
  var scanSubscription = flutterBlue.scan().listen((scanResult) {
    // do something with scan result
    device = scanResult.device;
    print('${device.name} found! rssi: ${scanResult.rssi}');
  });

  /// Stop scanning
  scanSubscription.cancel();
}