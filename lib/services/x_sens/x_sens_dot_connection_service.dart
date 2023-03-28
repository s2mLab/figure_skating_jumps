import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/enums/event_channel_names.dart';
import 'package:figure_skating_jumps/interfaces/i_observable.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../enums/method_channel_names.dart';
import '../../enums/x_sens_device_state.dart';
import '../../interfaces/i_x_sens_state_subscriber.dart';
import '../../models/bluetooth_device.dart';
import '../../models/db_models/device_name.dart';
import '../manager/device_names_manager.dart';

class XSensDotConnectionService
    implements IObservable<IXSensStateSubscriber, XSensDeviceState> {
  static final _xSensConnectionMethodChannel =
      MethodChannel(MethodChannelNames.connectionChannel.channelName);
  static final _xSensConnectionEventChannel = EventChannel(EventChannelNames.connectionChannel.channelName);
  static final XSensDotConnectionService _xSensDotConnection =
      XSensDotConnectionService._internal();
  final List<IXSensStateSubscriber> _subscribers = [];
  static XSensDeviceState _connectionState = XSensDeviceState.disconnected;
  BluetoothDevice? _currentXSensDevice;

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory XSensDotConnectionService() {
    _xSensConnectionEventChannel.receiveBroadcastStream().listen((event) {
      _changeState(event as int);
    });
    return _xSensDotConnection;
  }

  XSensDotConnectionService._internal();

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
        _currentXSensDevice = bluetoothDevice;

        DeviceName? deviceName = DeviceNamesManager()
            .preferences
            .firstWhereOrNull((iter) =>
                _currentXSensDevice!.macAddress == iter.deviceMacAddress);
        if (deviceName != null) {
          _currentXSensDevice!.assignedName = deviceName.name;
        } else {
          DeviceNamesManager().addDevice(
              UserClient().currentAuthUser!.uid, _currentXSensDevice!);
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
    XSensDeviceState? newState = XSensDeviceState.values.firstWhereOrNull((element) => element.state == state);
    if(newState == null) return;
    XSensDotConnectionService().notifySubscribers(newState);
  }

  @override
  void notifySubscribers(XSensDeviceState state) {
    _connectionState = state;
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
