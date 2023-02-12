import '../models/bluetooth_device.dart';

abstract class BluetoothDiscoverySubscriber {
  void onBluetoothDeviceListChange(List<BluetoothDevice> devices);
}
