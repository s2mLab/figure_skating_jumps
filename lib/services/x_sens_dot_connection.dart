import 'package:figure_skating_jumps/services/x_sens_dot_channel_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../enums/x_sens_connection_state.dart';
import '../interfaces/i_x_sens_state_subscriber.dart';
import '../models/bluetooth_device.dart';

class XSensDotConnection {
  static const _xSensChannel = MethodChannel('xsens-dot-channel');
  static final XSensDotConnection _xSensDotConnection =
      XSensDotConnection._internal(XSensConnectionState.disconnected);
  final List<IXSensStateSubscriber> _connectionStateSubscribers = [];
  XSensConnectionState _connectionState;
  BluetoothDevice? _currentXSensDevice;

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory XSensDotConnection() {
    return _xSensDotConnection;
  }

  XSensDotConnection._internal(this._connectionState);

  XSensConnectionState subscribeConnectionState(
      IXSensStateSubscriber subscriber) {
    _connectionStateSubscribers.add(subscriber);
    return getState();
  }

  XSensConnectionState getState() {
    return _connectionState;
  }

  Future<bool> connect(BluetoothDevice bluetoothDevice) async {
    if(_currentXSensDevice == null){
      String response = await XSensDotChannelService().connectXSensDot(macAddress: bluetoothDevice.macAddress);
      if(response == bluetoothDevice.macAddress) {
        _currentXSensDevice = bluetoothDevice;
        _changeState(XSensConnectionState.connected);
      }
      return response == bluetoothDevice.macAddress;
    }

    return false;
  }

  Future<void> disconnect() async {
    if(_currentXSensDevice != null){
      String response = await XSensDotChannelService().disconnectXSensDot();
      String? currentMac = _currentXSensDevice?.macAddress;
      if(response.contains(currentMac!)) {
        _currentXSensDevice = null;
        _changeState(XSensConnectionState.disconnected);
      }
    }
  }

  Future<void> setRate(int rate) async {
    try {
      await _xSensChannel
          .invokeMethod('setRate', <String, dynamic>{'rate': rate});
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  void _changeState(XSensConnectionState state) {
    _connectionState = state;
    for (IXSensStateSubscriber s in _connectionStateSubscribers) {
      s.onStateChange(state);
    }
  }
}
