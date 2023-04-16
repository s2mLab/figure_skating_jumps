import 'dart:async';

import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/enums/event_channel_names.dart';
import 'package:figure_skating_jumps/enums/method_channel_names.dart';
import 'package:figure_skating_jumps/enums/x_sens/x_sens_device_state.dart';
import 'package:figure_skating_jumps/interfaces/i_observable.dart';
import 'package:figure_skating_jumps/interfaces/i_x_sens_state_subscriber.dart';
import 'package:figure_skating_jumps/models/local_db/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/local_db/bluetooth_device_manager.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class XSensDotConnectionService
    implements IObservable<IXSensStateSubscriber, XSensDeviceState> {
  static final _xSensConnectionMethodChannel =
      MethodChannel(MethodChannelNames.connectionChannel.channelName);
  static final _xSensConnectionEventChannel =
      EventChannel(EventChannelNames.connectionChannel.channelName);
  static final XSensDotConnectionService _xSensDotConnection =
      XSensDotConnectionService._internal();
  final List<IXSensStateSubscriber> _subscribers = [];
  static XSensDeviceState _connectionState = XSensDeviceState.disconnected;
  static BluetoothDevice? _currentXSensDevice;
  static Timer? _errorTimer;
  static const Duration _maxDelay = Duration(seconds: 30);

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory XSensDotConnectionService() {
    _xSensConnectionEventChannel.receiveBroadcastStream().listen((event) {
      _changeState(event as int);
    });
    return _xSensDotConnection;
  }

  XSensDotConnectionService._internal();

  bool get isInitialized {
    return _connectionState == XSensDeviceState.initialized;
  }

  XSensDeviceState get connectionState {
    return _connectionState;
  }

  BluetoothDevice? get currentXSensDevice {
    return _currentXSensDevice;
  }

  Future<bool> connect(BluetoothDevice bluetoothDevice) async {
    if (_currentXSensDevice == null) {
      bool response = false;
      try {
        await _xSensConnectionMethodChannel.invokeMethod('connectXSensDot',
            <String, dynamic>{'address': bluetoothDevice.macAddress});
        response = true;
      } on PlatformException catch (e) {
        debugPrint(e.message!);
      }
      if (response) {
        _currentXSensDevice = BluetoothDevice(
            macAddress: bluetoothDevice.macAddress,
            userId: UserClient().currentSkatingUser!.uID!,
            name: bluetoothDevice.name,
            id: bluetoothDevice.id);

        BluetoothDevice? deviceName = BluetoothDeviceManager()
            .devices
            .firstWhereOrNull(
                (iter) => _currentXSensDevice!.macAddress == iter.macAddress);

        if (deviceName != null) {
          _currentXSensDevice!.name = deviceName.name;
        } else {
          BluetoothDeviceManager().addDevice(_currentXSensDevice!);
        }
      }
      return response;
    }

    return false;
  }

  Future<void> disconnect() async {
    try {
      await _xSensConnectionMethodChannel.invokeMethod('disconnectXSensDot');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
    _currentXSensDevice = null;
  }

  static void _changeState(int state) {
    XSensDeviceState? newState = XSensDeviceState.values
        .firstWhereOrNull((element) => element.state == state);
    if (newState == null) return;
    switch (newState) {
      case XSensDeviceState.disconnected:
      case XSensDeviceState.connected:
      case XSensDeviceState.initialized:
        _errorTimer?.cancel();
        _errorTimer = null;
        break;
      case XSensDeviceState.connecting:
      case XSensDeviceState.reconnecting:
      case XSensDeviceState.startReconnecting:
        _errorTimer?.cancel();
        _errorTimer = Timer(_maxDelay, () {
          XSensDotConnectionService()
              .notifySubscribers(XSensDeviceState.disconnected);
        });
        break;
    }
    XSensDotConnectionService().notifySubscribers(newState);
  }

  @override
  void notifySubscribers(XSensDeviceState state) {
    _connectionState = state;
    if(_connectionState == XSensDeviceState.disconnected) {
      _currentXSensDevice = null;
    }
    for (IXSensStateSubscriber s in _subscribers) {
      s.onStateChange(state);
    }
  }

  @override
  XSensDeviceState subscribe(IXSensStateSubscriber subscriber) {
    _subscribers.add(subscriber);
    return _connectionState;
  }

  @override
  void unsubscribe(IXSensStateSubscriber subscriber) {
    _subscribers.remove(subscriber);
  }
}
