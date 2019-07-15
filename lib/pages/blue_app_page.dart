import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:my_blue/pages/bluetooth_off_page.dart';
import 'package:my_blue/pages/search_device_page.dart';
import 'package:my_blue/blocs/bloc_provider.dart';
import 'package:my_blue/blocs/blue_app_bloc.dart';


class BlueAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BlueAppBloc _bloc = BlocProvider.of<BlueAppBloc>(context);
    return StreamBuilder<BluetoothState>(
      stream: _bloc.outBlueState,
      initialData: BluetoothState.unknown,

      builder: (buildContext, asyncSnapshot) {
        final state = asyncSnapshot.data;
        return (state == BluetoothState.on)
            ? SearchDevicePage()
            : BluetoothOffPage();
      },
    );
  }
}
