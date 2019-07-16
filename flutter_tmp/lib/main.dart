import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ajnauw',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String value; // 每次input的值
  List<int> allText = []; // 从本地文件获取的值

  /**
   * 此方法返回本地文件地址
   */
  Future<File> _getLocalFile() async {
    // 获取文档目录的路径
//    Directory appDocDir = new Directory("/storage/emulated/0");
    Directory appDocDir = await getApplicationDocumentsDirectory();
    print(appDocDir);
    String dir = appDocDir.path;
    print(dir);
//    final file = new File('$dir/test.txt');
    final file = new File('$dir/ble5_simple_peripheral_cc2640r2lp_app_FlashROM_OAD_Offchip.bin');
    print(file);
    return file;
  }

  /**
   * 保存value到本地文件里面
   */
  // void _saveValue() async {
  //   try {
  //     File f = await _getLocalFile();
  //     IOSink slink = f.openWrite(mode: FileMode.append);
  //     slink.write('$value\n');
  //     // await fs.writeAsString('$value');
  //     setState(() {
  //       value = '';
  //     });
  //     slink.close();
  //   } catch (e) {
  //     // 写入错误
  //     print(e);
  //   }
  // } 

  /**
   * 读取本地文件的内容
   */
  void _readContent() async {
    File file = await _getLocalFile();
    // 从文件中读取变量作为字符串，一次全部读完存在内存里面
    List<int> contents = await file.readAsBytes();
    setState(() {
      allText = contents;
    });
  }

  // 清空本地保存的文件
  // void _clearContent() async {
  //   File f = await _getLocalFile();
  //   await f.writeAsString('');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('demo'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 16.0),
                    child: TextField(
                      controller: TextEditingController(
                        text: value,
                      ),
                      onChanged: (String v) {
                        value = v;
                      },
                      onSubmitted: (String r) {
                        value = r;
                      },
                    ),
                  ),
                ),
                // RaisedButton(
                //   color: Theme.of(context).primaryColor,
                //   onPressed: _saveValue,
                //   child: Text('保存'),
                // ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      onPressed: _readContent,
                      child: Text('获取本地数据'),
                    ),
                    // RaisedButton(
                    //   color: Colors.red,
                    //   textColor: Colors.white,
                    //   onPressed: _clearContent,
                    //   child: Text('清空本地数据'),
                    // ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('''$allText'''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}