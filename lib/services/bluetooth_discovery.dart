import 'dart:async';

import 'package:figure_skating_jumps/interfaces/i_bluetooth_discovery_subscriber.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/x_sens_dot_channel_service.dart';

class BluetoothDiscovery {
  static final BluetoothDiscovery _bluetoothDiscovery =
      BluetoothDiscovery._internal();
  final List<IBluetoothDiscoverySubscriber> _subscribers = [];
  List<BluetoothDevice> _devices = [];

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory BluetoothDiscovery() {
    return _bluetoothDiscovery;
  }

  BluetoothDiscovery._internal();

  List<BluetoothDevice> subscribeBluetoothDiscovery(
      IBluetoothDiscoverySubscriber subscriber) {
    _subscribers.add(subscriber);
    return getDevices();
  }

  List<BluetoothDevice> getDevices() {
    return [
      ..._devices
    ]; //Deep copy for now, might be relevant to shallow copy in the end
  }

  void refreshFromKotlinHandle() async {
    XSensDotChannelService().startScan();
    Timer(const Duration(seconds: 5), () async {
      _devices = await XSensDotChannelService().stopScan();
      _notifySubscribers(getDevices());
    });
  }

  void _notifySubscribers(List<BluetoothDevice> devices) {
    for (IBluetoothDiscoverySubscriber s in _subscribers) {
      s.onBluetoothDeviceListChange(devices);
    }
  }
}
