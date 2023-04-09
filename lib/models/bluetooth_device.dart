import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/services/manager/bluetooth_device_manager.dart';
import 'package:figure_skating_jumps/services/user_client.dart';

import 'db_models/abstract_local_db_object.dart';

class BluetoothDevice extends AbstractLocalDbObject {
  late final String _userId;
  late final String _macAddress;
  late String _name;

  String get userId {
    return _userId;
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

  BluetoothDevice({required String macAddress, required String userId, String name = "XSens Dot", int? id}) {
    name.trim().isEmpty
        ? throw ArgumentError(
            ['Can\'t create class with empty argument', '_name'])
        : _name = name;
    macAddress.trim().isEmpty
        ? throw ArgumentError(
            ['Can\'t create class with empty argument', '_macAddress'])
        : _macAddress = macAddress;
    BluetoothDevice? savedDevice = BluetoothDeviceManager().devices.firstWhereOrNull((el) => el.macAddress == _macAddress);
    _name = savedDevice?._name ?? "XSens Dot";
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
      'userID': _userId,
      'macAddress': _macAddress,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'BluetoothDevice{id: $id, userID: $_userId, name: $_name, deviceMacAddress: $_macAddress}';
  }
}
