import 'package:flutter/cupertino.dart';

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
    _assignedName = _name;
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
