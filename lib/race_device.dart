/// 作为赛车设备的抽象
class RaceDevice{
  // 单例
  static RaceDevice _raceDevice;   
//  static RaceDevice get instance => _raceDevice;

  ConnectConfig config;

  RaceDevice(this.config){
    if(config == null){
      config = new ConnectConfig();
    }


  }
}

/// 设备状态
/// 升级, 连接, 未连接
enum DeviceState{
  UPDATE,
  CONNECTED,
  DISCONNECT,
}

/// 连接配置文件
class ConnectConfig{
  // 这里初始化默认的配置
  // 基本设置
  int baudRate = 469899;
  int dataBits = 8;
  // parity... stopBits...
  // 串口设置数据包长度
  int readBufferSize = 4096;
  int writeBufferSize = 4096;
  int receivedBytesThreshold = 25;  // ?


  // ConnectConfig({}){
  //   /// todo
  // }
}