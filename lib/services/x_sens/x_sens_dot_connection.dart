import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_channel_service.dart';
import '../../enums/x_sens_connection_state.dart';
import '../../interfaces/i_x_sens_state_subscriber.dart';
import '../../models/bluetooth_device.dart';
import '../../models/db_models/device_names.dart';
import '../manager/device_names_manager.dart';

class XSensDotConnection {
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
    return _connectionState;
  }

  XSensConnectionState get connectionState {
    return _connectionState;
  }

  BluetoothDevice? get currentXSensDevice {
    if (_currentXSensDevice == null) return null;
    return BluetoothDevice.deepClone(_currentXSensDevice!);
  }

  Future<bool> connect(BluetoothDevice bluetoothDevice) async {
    if (_currentXSensDevice == null) {
      String response = await XSensDotChannelService()
          .connectXSensDot(macAddress: bluetoothDevice.macAddress);
      if (response == bluetoothDevice.macAddress) {
        _currentXSensDevice = bluetoothDevice;

        DeviceNames? deviceName = DeviceNamesManager().preferences.firstWhereOrNull((iter) => _currentXSensDevice!.macAddress == iter.deviceMacAddress);
        if (deviceName != null) {
          _currentXSensDevice!.assignedName = deviceName.name;
        } else {
          DeviceNamesManager().addDevice(UserClient().currentAuthUser!.uid, _currentXSensDevice!);
        }
        _changeState(XSensConnectionState.connected);
      }
      return response == bluetoothDevice.macAddress;
    }

    return false;
  }

  Future<void> disconnect() async {
    if (_currentXSensDevice != null) {
      String response = await XSensDotChannelService().disconnectXSensDot();
      String? currentMac = _currentXSensDevice?.macAddress;
      if (response.contains(currentMac!)) {
        _currentXSensDevice = null;
        _changeState(XSensConnectionState.disconnected);
      }
    }
  }

  void _changeState(XSensConnectionState state) {
    _connectionState = state;
    for (IXSensStateSubscriber s in _connectionStateSubscribers) {
      s.onStateChange(state);
    }
  }
}
