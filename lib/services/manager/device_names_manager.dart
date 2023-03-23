import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/models/db_models/device_name.dart';
import 'package:figure_skating_jumps/services/local_db_service.dart';

class DeviceNamesManager implements ILocalDbManager<DeviceName> {
  static final DeviceNamesManager _deviceNamesManager =
      DeviceNamesManager._internal();

  List<DeviceName> _preferences = [];

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory DeviceNamesManager() {
    return _deviceNamesManager;
  }

  DeviceNamesManager._internal();

  List<DeviceName> get preferences {
    return _preferences;
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
    _preferences = constructObject(await LocalDbService()
        .readWhere(LocalDbService.deviceNamesTableName, "userID", userID));
  }

  Future<void> addDevice(String userID, BluetoothDevice device) async {
    DeviceName deviceToAdd = DeviceName(
        userID: userID, deviceMacAddress: device.macAddress, name: device.name);
    int id = await LocalDbService()
        .insertOne(deviceToAdd, LocalDbService.deviceNamesTableName);
    deviceToAdd.id = id;
    _preferences.add(deviceToAdd);
  }

  Future<void> changeName(String name, BluetoothDevice device) async {
    DeviceName deviceName = _preferences
        .firstWhere((iter) => iter.deviceMacAddress == device.macAddress);
    deviceName.name = name;
    await LocalDbService()
        .updateOne(deviceName, LocalDbService.deviceNamesTableName);
  }
}
