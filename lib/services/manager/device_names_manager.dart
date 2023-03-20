import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/models/db_models/device_names.dart';
import 'package:figure_skating_jumps/services/local_db_service.dart';
import 'package:figure_skating_jumps/services/user_client.dart';

class DeviceNamesManager implements ILocalDbManager<DeviceNames> {
  static final DeviceNamesManager _userPreferencesManager =
      DeviceNamesManager._internal();

  List<DeviceNames> _preferences = [];

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory DeviceNamesManager() {
    return _userPreferencesManager;
  }

  DeviceNamesManager._internal();

  List<DeviceNames> get preferences {
    return _preferences;
  }

  @override
  List<DeviceNames> constructObject(List<Map<String, dynamic>> map) {
    return List.generate(map.length, (i) {
      return DeviceNames(
        id: map[i]['id'],
        userID: map[i]['userID'],
        deviceMacAddress: map[i]['deviceMacAddress'],
        name: map[i]['customName'],
      );
    });
  }

  Future<void> loadDeviceNames(String userID) async {
    _preferences = constructObject(await LocalDbService()
        .readWhere(LocalDbService.deviceNamesTableName, "userID", userID));
  }

  Future<void> addDevice(String userID, BluetoothDevice device) async {
    DeviceNames deviceToAdd = DeviceNames(
        userID: userID, deviceMacAddress: device.macAddress, name: device.name);
    int id = await LocalDbService()
        .insertOne(deviceToAdd, LocalDbService.deviceNamesTableName);
    deviceToAdd.id = id;
    _preferences.add(deviceToAdd);
  }

  Future<void> changeName(String name, BluetoothDevice device) async {
    _preferences
        .firstWhere((iter) => iter.deviceMacAddress == device.macAddress)
        .name = name;
    await LocalDbService().updateOne(
        DeviceNames(
            userID: UserClient().currentAuthUser!.uid,
            deviceMacAddress: device.macAddress,
            name: name),
        LocalDbService.deviceNamesTableName);
  }
}
