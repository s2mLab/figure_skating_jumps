import 'package:figure_skating_jumps/interfaces/i_bluetooth_discovery_subscriber.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';

class BluetoothDiscovery {
  static final BluetoothDevice _sampleDevice = BluetoothDevice(
      'XSens_Dot_A12Xx123A',
      '00-B0-D0-63-C2-26',
      0.3); // TODO: remove hardcoded when connexion exists
  static final BluetoothDiscovery _bluetoothDiscovery =
      BluetoothDiscovery._internal();
  final List<IBluetoothDiscoverySubscriber> _subscribers = [];
  List<BluetoothDevice> _devices = [
    // TODO: remove hardcoded when connexion exists
    _sampleDevice,
    BluetoothDevice.deepClone(_sampleDevice),
    BluetoothDevice.deepClone(_sampleDevice),
    BluetoothDevice.deepClone(_sampleDevice)
  ];

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

  // TODO: implement communication with underlying bluetooth channel
  void refreshFromJavaHandle() {
    _devices = [
      ..._devices
    ]; // Reassigns to itself for now to justify non final device list
  }

  // Temporarily public for testing purposes
  // TODO: Privatize and maybe remove
  void changeList() {
    _devices.add(BluetoothDevice.deepClone(_sampleDevice));
    _notifySubscribers(getDevices());
  }

  // TODO: testing purposes only waiting for connection
  void removeEntry() {
    _devices.removeAt(0);
    _notifySubscribers(getDevices());
  }

  void _notifySubscribers(List<BluetoothDevice> devices) {
    for (IBluetoothDiscoverySubscriber s in _subscribers) {
      s.onBluetoothDeviceListChange(devices);
    }
  }
}
