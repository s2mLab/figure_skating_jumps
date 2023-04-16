import 'package:figure_skating_jumps/models/local_db/bluetooth_device.dart';

abstract class IBluetoothDiscoverySubscriber {
  void onBluetoothDeviceListChange(List<BluetoothDevice> devices);
}
