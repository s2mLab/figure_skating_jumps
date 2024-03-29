import 'package:figure_skating_jumps/enums/models/season.dart';
import 'package:figure_skating_jumps/models/local_db/abstract_local_db_object.dart';

class GlobalSettings extends AbstractLocalDbObject {
  final Season _season;

  GlobalSettings({id, required Season season}) : _season = season {
    this.id = id;
  }

  Season get season {
    return _season;
  }

  @override
  Map<String, dynamic> toMap() {
    return {'season': _season.name};
  }

  @override
  String toString() {
    return 'GlobalSettings{id: $id, season: $_season}';
  }
}
