import 'dart:async';
import 'package:flutter/material.dart';

/// 作为所有BloC的通用接口
abstract class BlocBase {
  void dispose();
}

/// BLoC provider
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc;
  final Widget child;

  BlocProvider({Key key, @required this.bloc, @required this.child})
      : super(key: key);

  @override
  _BlocProviderState<T> createState() => new _BlocProviderState<T>();

  /// 用来获取 bloc
  static T of<T extends BlocBase>(BuildContext context) {
    // 获取BlocProvider的 T 保存到 变量 type 中
    final Type type = _typeOf<BlocProvider<T>>();

    // 通过 ancestorWidgetOfExactType 获取 provider ?
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    super.dispose();
    widget.bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
