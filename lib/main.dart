import 'package:flutter/material.dart';
import 'package:my_blue/page_main.dart';
import 'package:my_blue/race_device.dart';

void main()=>runApp(new MyApp());

RaceDevice device = new RaceDevice(null);   // todo

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "一个示例",
      home: MainPage(),
    );
  }
}

