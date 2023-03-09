import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/db_models/user_preferences.dart';

class UserPreferencesManager implements ILocalDbManager<UserPreferences> {
  static final UserPreferencesManager _userPreferencesManager =
      UserPreferencesManager._internal();

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory UserPreferencesManager() {
    return _userPreferencesManager;
  }

  UserPreferencesManager._internal();

  @override
  List<UserPreferences> constructObject(List<Map<String, dynamic>> map) {
    return List.generate(map.length, (i) {
      return UserPreferences(
        id: map[i]['id'],
        userID: map[i]['userID'],
        deviceMacAddresses: map[i]['deviceMacAddresses'],
      );
    });
  }


}
