import 'package:flutter_blue/flutter_blue.dart';

import 'bloc_provider.dart';

///
/// 暂时废弃,.................
class NotificationsBloc implements BaseBloc{
  final BluetoothCharacteristic characteristic;

  NotificationsBloc(this.characteristic);

  @override
  void dispose() {
  }

}