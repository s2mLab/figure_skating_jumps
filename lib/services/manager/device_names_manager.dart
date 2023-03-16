import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/db_models/device_names.dart';
import 'package:figure_skating_jumps/services/local_db_service.dart';

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

  @override
  List<DeviceNames> constructObject(List<Map<String, dynamic>> map) {
    return List.generate(map.length, (i) {
      return DeviceNames(
        id: map[i]['id'],
        userID: map[i]['userID'],
        deviceMacAddress: map[i]['deviceMacAddress'],
      );
    });
  }

  Future<void> loadUserPreferences(String userID) async {
    try {
      _preferences = constructObject(await LocalDbService().readWhere(LocalDbService.preferencesTableName, "userID", userID));
    } catch (e) {
      rethrow;
    }
  }
}
