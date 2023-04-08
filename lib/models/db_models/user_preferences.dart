import '../../enums/season.dart';
import 'abstract_local_db_object.dart';

class UserPreferences extends AbstractLocalDbObject {
  final Season _season;

  UserPreferences({id, required Season season})
      : _season = season {
    this.id = id;
  }

  get season {
    return _season;
  }

  @override
  Map<String, dynamic> toMap() {
    return {'season': _season};
  }

  @override
  String toString() {
    return 'UserPreference{id: $id, season: $_season}';
  }
}
