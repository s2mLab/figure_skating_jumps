import 'package:figure_skating_jumps/models/local_db/bluetooth_device.dart';

/// Interface for subscribing to changes in the list of Bluetooth devices discovered during discovery process.
abstract class IBluetoothDiscoverySubscriber {
  /// Override this method to handle the changes in the list of Bluetooth devices.
  ///
  /// Parameters:
  /// - [devices] : A list of [BluetoothDevice] objects representing the devices discovered during the discovery process.
  void onBluetoothDeviceListChange(List<BluetoothDevice> devices);
}
