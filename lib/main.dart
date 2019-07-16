import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'blocs/bloc_provider.dart';
import 'blocs/blue_app_bloc.dart';
import 'pages/blue_app_page.dart';

// 这里的BLoC可能对性能造成影响
void main() async {
//  Map<PermissionGroup, PermissionStatus> permissions =
//  await PermissionHandler().requestPermissions([PermissionGroup.storage]);
//  await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
//  await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.storage);


  return runApp(MaterialApp(
    title: "bluetooth demo",
    theme: ThemeData(primaryColor: Colors.lightBlue),
    home: BlocProvider<BlueAppBloc>(
      bloc: BlueAppBloc(),
      child: BlueAppPage(),
    ),
  ));
}

//class BlueApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder<BluetoothState>(
//        stream: FlutterBlue.instance.state,
//        initialData: BluetoothState.unknown,
//        builder: (buildContext, asyncSnapshot) {
//          final state = asyncSnapshot.data;
//          if (state == BluetoothState.on) {
//            return SearchDeviceScreen();
//          }
//          return BluetoothOffScreen();
//        });
//  }
//}
