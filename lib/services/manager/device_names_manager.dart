import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/models/db_models/device_name.dart';
import 'package:figure_skating_jumps/services/local_db_service.dart';
import 'package:flutter/cupertino.dart';

class DeviceNamesManager implements ILocalDbManager<DeviceName> {
  static final DeviceNamesManager _deviceNamesManager =
      DeviceNamesManager._internal();

  List<DeviceName> _deviceNames = [];

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory DeviceNamesManager() {
    return _deviceNamesManager;
  }

  DeviceNamesManager._internal();

  List<DeviceName> get deviceNames {
    return _deviceNames;
  }

  @override
  List<DeviceName> constructObject(List<Map<String, dynamic>> objMaps) {
    return List.generate(objMaps.length, (i) {
      return DeviceName(
        id: objMaps[i]['id'],
        userID: objMaps[i]['userID'],
        deviceMacAddress: objMaps[i]['deviceMacAddress'],
        name: objMaps[i]['customName'] ?? "",
      );
    });
  }

  Future<void> loadDeviceNames(String userID) async {
    _deviceNames = constructObject(await LocalDbService()
        .readWhere(LocalDbService.deviceNamesTableName, "userID", userID));
  }

  Future<void> addDevice(String userID, BluetoothDevice device) async {
    DeviceName deviceToAdd = DeviceName(
        userID: userID, deviceMacAddress: device.macAddress, name: device.name);
    int id = await LocalDbService()
        .insertOne(deviceToAdd, LocalDbService.deviceNamesTableName);
    deviceToAdd.id = id;
    _deviceNames.add(deviceToAdd);
  }

  Future<void> removeDevice(BluetoothDevice device) async {
    DeviceName? deviceToRemove = _deviceNames
        .firstWhereOrNull((el) => el.deviceMacAddress == device.macAddress);
    if(deviceToRemove == null){
      debugPrint("Could not find device ${device.macAddress} in local storage");
      return;
    }
    await LocalDbService().deleteOne(deviceToRemove, LocalDbService.deviceNamesTableName);
    _deviceNames.remove(deviceToRemove);
  }

  Future<void> changeName(String name, BluetoothDevice device) async {
    DeviceName deviceName = _deviceNames
        .firstWhere((iter) => iter.deviceMacAddress == device.macAddress);
    deviceName.name = name;
    await LocalDbService()
        .updateOne(deviceName, LocalDbService.deviceNamesTableName);
  }
}
