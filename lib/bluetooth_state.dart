
class BluetoothState {
  _BluetoothState _currentState;

  @override
  int get hashCode => super.hashCode;
  @override
  operator ==(Object obj) {
    return obj is BluetoothState && obj._currentState == this._currentState;
  }

  bool isEnable() {
    return this._currentState == _BluetoothState.STATE_BLE_ON;
  }
}

enum _BluetoothState {
  STATE_OFF,
  STATE_TURNING_ON,
  STATE_ON,
  STATE_TURNING_OFF,
  STATE_BLE_OFF,
  STATE_BLE_TURNING_ON,
  STATE_BLE_ON,
  STATE_BLE_TURNING_OFF,

  STATE_ERROR,

  STATE_UNKNOWN,
}
