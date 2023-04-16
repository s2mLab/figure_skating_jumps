import 'package:figure_skating_jumps/enums/season.dart';
import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/local_db/global_settings.dart';
import 'package:figure_skating_jumps/services/local_db/local_db_service.dart';

class GlobalSettingsManager implements ILocalDbManager<GlobalSettings> {
  static GlobalSettings? _settings;
  static final GlobalSettingsManager _globalSettingsManager =
      GlobalSettingsManager._internal();

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory GlobalSettingsManager() {
    return _globalSettingsManager;
  }

  GlobalSettingsManager._internal();

  @override
  List<GlobalSettings> constructObject(List<Map<String, dynamic>> objMaps) {
    return List.generate(objMaps.length, (i) {
      return GlobalSettings(
          id: objMaps[i]['id'],
          season: Season.values.byName(objMaps[i]['season']));
    });
  }

  GlobalSettings? get settings {
    return _settings;
  }

  Future<void> saveSettings(GlobalSettings settings) async {
    _settings = settings;
    _settings?.id = 1;
    bool alreadyExists = await LocalDbService()
        .updateOne(_settings!, LocalDbService.globalSettingsTableName);
    if (!alreadyExists) {
      await LocalDbService()
          .insertOne(_settings!, LocalDbService.globalSettingsTableName);
    }
  }

  Future<void> loadSettings() async {
    List<GlobalSettings> settingsList = constructObject(await LocalDbService()
        .readWhere(LocalDbService.globalSettingsTableName, 'id', '1'));
    if (settingsList.isNotEmpty) _settings = settingsList[0];
  }
}
