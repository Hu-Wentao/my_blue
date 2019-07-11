import 'package:flutter_blue/flutter_blue.dart';

import 'bloc_provider.dart';

class NotificationsBloc implements BaseBloc{
  final BluetoothCharacteristic characteristic;

  NotificationsBloc(this.characteristic);



  @override
  void dispose() {
  }

}