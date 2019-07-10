import 'package:flutter_blue/flutter_blue.dart';

import 'bloc_provider.dart';

/// 包装Flutter_blue， 未来考虑替换。。。
class BlueAppBloc implements BaseBloc {
  // 获取蓝牙状态
  Stream<BluetoothState> get outBlueState => FlutterBlue.instance.state;
  @override
  void dispose() {}
}
