import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/db_models/local_capture.dart';
import 'package:figure_skating_jumps/services/local_db_service.dart';

class LocalCapturesManager implements ILocalDbManager<LocalCapture> {
  static const String pathToFiles = "testing";

  static final LocalCapturesManager _localCapturesManager =
      LocalCapturesManager._internal();

  final List<LocalCapture> _localCaptures = [];

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory LocalCapturesManager() {
    return _localCapturesManager;
  }

  LocalCapturesManager._internal();

  List<LocalCapture> get localCaptures {
    return _localCaptures;
  }

  @override
  List<LocalCapture> constructObject(List<Map<String, dynamic>> objMaps) {
    return List.generate(objMaps.length, (i) {
      return LocalCapture(
        id: objMaps[i]['id'],
        captureID: objMaps[i]['captureID'],
        path: objMaps[i]['path'],
      );
    });
  }

  Future<int> saveCapture(LocalCapture capture) async {
    return await LocalDbService()
        .insertOne(capture, LocalDbService.localCapturesTableName);
  }

  Future<LocalCapture?> getCapture(String captureID) async {
    List<LocalCapture> captures = constructObject(await LocalDbService()
        .readWhere(
            LocalDbService.localCapturesTableName, "captureID", captureID));
    return captures.length == 1 ? captures[0] : null;
  }

  Future<int> deleteCapture(String captureID) async {
    return await LocalDbService().deleteWhere(
        LocalDbService.localCapturesTableName, 'captureID', captureID);
  }
}
