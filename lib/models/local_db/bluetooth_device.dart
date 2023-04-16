import 'package:figure_skating_jumps/models/local_db/abstract_local_db_object.dart';
import 'package:figure_skating_jumps/services/local_db/bluetooth_device_manager.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';

class BluetoothDevice extends AbstractLocalDbObject {
  late final String _userId;
  late final String _macAddress;
  late String _name;

  static const defaultName = "XSens Dot";

  String get userId {
    return _userId;
  }

  set userId(String val) {
    if (val.isNotEmpty) {
      _userId = val;
    }
  }

  String get macAddress {
    return _macAddress;
  }

  String get name {
    return _name;
  }

  set name(String val) {
    if (val.isNotEmpty) {
      _name = val;
      BluetoothDeviceManager().updateDevice(this);
    }
  }

  BluetoothDevice({required String macAddress, required String userId, String name = defaultName, int? id}) {
    name.trim().isEmpty
        ? throw ArgumentError(
            ['Can\'t create class with empty argument', '_name'])
        : _name = name;
    macAddress.trim().isEmpty
        ? throw ArgumentError(
            ['Can\'t create class with empty argument', '_macAddress'])
        : _macAddress = macAddress;
    _userId = userId;
    this.id = id;
  }

  factory BluetoothDevice.fromEvent(String event) {
    var splitEvent = event.split(",");
    if (splitEvent.length != 2) {
      throw ArgumentError(
          ['Can\'t create class with wrong format', 'event']);
    }
    return BluetoothDevice(macAddress: splitEvent.first, userId: UserClient().currentSkatingUser!.uID!, name: splitEvent.last);
  }

  BluetoothDevice.deepClone(BluetoothDevice toBeDeepClonedDevice) {
    _userId = toBeDeepClonedDevice.userId;
    _macAddress = toBeDeepClonedDevice.macAddress;
    _name = toBeDeepClonedDevice.name;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': _userId,
      'macAddress': _macAddress,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'BluetoothDevice{id: $id, userId: $_userId, name: $_name, deviceMacAddress: $_macAddress}';
  }
}
