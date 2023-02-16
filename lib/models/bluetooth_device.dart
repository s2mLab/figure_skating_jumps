class BluetoothDevice {
  late final String _name;
  late final String _macAddress;
  late final double _signalStrength;
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

  double get signalStrength {
    return _signalStrength;
  }

  BluetoothDevice(String name, String macAddress, double signalStrength) {
    name.trim().isEmpty
        ? throw ArgumentError(
            ['Can\'t create class with empty argument', '_name'])
        : _name = name;
    macAddress.trim().isEmpty
        ? throw ArgumentError(
            ['Can\'t create class with empty argument', '_macAddress'])
        : _macAddress = macAddress;
    signalStrength == 0
        ? throw ArgumentError([
            'Can\'t create class with value 0 for argument',
            '_signalStrength'
          ])
        : _signalStrength = signalStrength;
    _assignedName = _name;
  }

  BluetoothDevice.deepClone(BluetoothDevice toBeDeepClonedDevice) {
    _name = toBeDeepClonedDevice.name;
    _macAddress = toBeDeepClonedDevice.macAddress;
    _signalStrength = toBeDeepClonedDevice.signalStrength;
    _assignedName = toBeDeepClonedDevice.assignedName;
  }
}
