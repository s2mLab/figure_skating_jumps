import 'package:figure_skating_jumps/models/db_models/abstract_local_db_object.dart';

class LocalCapture extends AbstractLocalDbObject {
  final String _captureID;
  final String _videoPath;

  LocalCapture({
    int? id,
    required String captureID,
    required String videoPath
  }): _captureID = captureID, _videoPath = videoPath;

  get captureID {
    return _captureID;
  }

  get videoPath {
    return _videoPath;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'captureID': _captureID,
      'path': _videoPath,
    };
  }

  @override
  String toString() {
    return 'DeviceName{id: $id, captureID: $_captureID, path: $_videoPath}';
  }
}