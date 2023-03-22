import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_channel_service.dart';
import '../../enums/x_sens_device_state.dart';
import '../../interfaces/i_x_sens_state_subscriber.dart';
import '../../models/bluetooth_device.dart';

class XSensDotConnectionService {
  static final XSensDotConnectionService _xSensDotConnection =
      XSensDotConnectionService._internal(XSensDeviceState.disconnected);
  final List<IXSensStateSubscriber> _connectionStateSubscribers = [];
  XSensDeviceState _connectionState;
  BluetoothDevice? _currentXSensDevice;

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory XSensDotConnectionService() {
    return _xSensDotConnection;
  }

  XSensDotConnectionService._internal(this._connectionState);

  XSensDeviceState subscribeConnectionState(
      IXSensStateSubscriber subscriber) {
    _connectionStateSubscribers.add(subscriber);
    return _connectionState;
  }

  XSensDeviceState get connectionState {
    return _connectionState;
  }

  BluetoothDevice? get currentXSensDevice {
    if (_currentXSensDevice == null) return null;
    return BluetoothDevice.deepClone(_currentXSensDevice!);
  }

  Future<bool> connect(BluetoothDevice bluetoothDevice) async {
    if (_currentXSensDevice == null) {
      bool response = await XSensDotChannelService()
          .connectXSensDot(macAddress: bluetoothDevice.macAddress);
      if (response) {
        _currentXSensDevice = bluetoothDevice;
        _changeState(XSensDeviceState.connected);
      }
      return response;
    }

    return false;
  }

  Future<void> disconnect() async {
    await XSensDotChannelService().disconnectXSensDot();
    _currentXSensDevice = null;
    _changeState(XSensDeviceState.disconnected);
  }

  void _changeState(XSensDeviceState state) {
    _connectionState = state;
    for (IXSensStateSubscriber s in _connectionStateSubscribers) {
      s.onStateChange(state);
    }
  }
}