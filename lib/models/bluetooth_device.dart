import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/services/manager/device_names_manager.dart';

import 'db_models/device_name.dart';

class BluetoothDevice {
  late final String _name;
  late final String _macAddress;
  late String _assignedName;

  String get name {
    return _name;
  }

  String get macAddress {
    return _macAddress;
  }

  String get assignedName {
    return _assignedName;
  }

  set assignedName(String val) {
    if (val.isNotEmpty) {
      _assignedName = val;
      DeviceNamesManager().changeName(val, this);
    }
  }

  BluetoothDevice(String macAddress, String name) {
    name.trim().isEmpty
        ? throw ArgumentError(
            ['Can\'t create class with empty argument', '_name'])
        : _name = name;
    macAddress.trim().isEmpty
        ? throw ArgumentError(
            ['Can\'t create class with empty argument', '_macAddress'])
        : _macAddress = macAddress;
    DeviceName? savedDevice = DeviceNamesManager().preferences.firstWhereOrNull((el) => el.deviceMacAddress == _macAddress);
    _assignedName = savedDevice == null ? _name : savedDevice.name;
  }

  factory BluetoothDevice.fromEvent(String event) {
    var splitEvent = event.split(",");
    if (splitEvent.length != 2) {
      throw ArgumentError(
          ['Can\'t create class with wrong format', 'event']);
    }
    return BluetoothDevice(splitEvent.first, splitEvent.last);
  }

  BluetoothDevice.deepClone(BluetoothDevice toBeDeepClonedDevice) {
    _name = toBeDeepClonedDevice.name;
    _macAddress = toBeDeepClonedDevice.macAddress;
    _assignedName = toBeDeepClonedDevice.assignedName;
  }
}
