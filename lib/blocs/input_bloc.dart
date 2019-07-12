import 'dart:async';

import 'bloc_provider.dart';

class InputBloc implements BaseBloc{
  // 数据流,
  StreamController<String>_dataController = StreamController<String>();
  // [_dataController]获取数据    ### 外部调用
  StreamSink<String> get inDataAddInputData => _dataController.sink;
  // [_dataController]输出数据
  Stream get outGetInputData => _dataController.stream;

  // 用户操作流
  StreamController _actionController = StreamController();
  // 用户输入事件, 点击了 发送 按钮,  ### 供外部调用
  StreamSink get inActionTapBtn => _actionController.sink;
  // 用户动作输出
  Stream get outAction => _actionController.stream;

  InputBloc(){
//    this.inActionTapBtn.
//    this.outGetInputData.listen(_onData);
  }

  void _onData(event){


  }

  @override
  void dispose() {
    _dataController.close();
    _actionController.close();
    // TODO: implement dispose
  }
}