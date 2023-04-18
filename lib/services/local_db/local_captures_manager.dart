import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/local_db/local_capture.dart';
import 'package:figure_skating_jumps/services/local_db/local_db_service.dart';

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
        videoPath: objMaps[i]['path'],
      );
    });
  }

  /// Saves the path to the capture in the local database.
  ///
  /// Parameters:
  /// - [capture] : the [LocalCapture] to be saved.
  ///
  /// Returns the id of the entity in the database.
  Future<int> saveCapture(LocalCapture capture) async {
    return await LocalDbService()
        .insertOne(capture, LocalDbService.localCapturesTableName);
  }

  /// Saves the path to the capture in the local database.
  ///
  /// Parameters:
  /// - [captureID] : the id of the [LocalCapture] to get.
  ///
  /// Returns the [LocalCapture].
  /// It can also return null if it finds more or less than one object with the id.
  Future<LocalCapture?> getCapture(String captureID) async {
    List<LocalCapture> captures = constructObject(await LocalDbService()
        .readWhere(
            LocalDbService.localCapturesTableName, "captureID", captureID));
    return captures.length == 1 ? captures[0] : null;
  }

  /// Deletes the capture from the local database.
  ///
  /// Parameters:
  /// - [captureID] : the id of the [LocalCapture] to delete.
  ///
  /// Returns the id of the entity in the database.
  Future<int> deleteCapture(String captureID) async {
    return await LocalDbService().deleteWhere(
        LocalDbService.localCapturesTableName, 'captureID', captureID);
  }
}
