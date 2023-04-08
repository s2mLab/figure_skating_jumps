import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/db_models/user_preferences.dart';
import 'package:figure_skating_jumps/services/local_db_service.dart';

import '../../enums/season.dart';

class UserPreferencesManager implements ILocalDbManager<UserPreferences> {
  static UserPreferences? _preferences;
  static final UserPreferencesManager _userPreferencesManager =
      UserPreferencesManager._internal();

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory UserPreferencesManager() {
    return _userPreferencesManager;
  }

  UserPreferencesManager._internal();

  @override
  List<UserPreferences> constructObject(List<Map<String, dynamic>> objMaps) {
    return List.generate(objMaps.length, (i) {
      return UserPreferences(
          id: objMaps[i]['id'], season: Season.values.byName(objMaps[i]['season']));
    });
  }

  UserPreferences? get preferences {
    return _preferences;
  }

  Future<void> savePreferences(UserPreferences preferences) async {
    _preferences = preferences;
    _preferences?.id = 1;
    bool alreadyExists = await LocalDbService()
        .updateOne(_preferences!, LocalDbService.userPreferencesTableName);
    if (!alreadyExists) {
      await LocalDbService()
          .insertOne(_preferences!, LocalDbService.userPreferencesTableName);
    }
  }

  Future<void> loadPreferences() async {
    List<UserPreferences> preferences = constructObject(await LocalDbService()
        .readWhere(LocalDbService.userPreferencesTableName, 'id', '1'));
    if (preferences.isNotEmpty) _preferences = preferences[0];
  }
}
