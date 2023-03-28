import 'package:figure_skating_jumps/models/db_models/abstract_local_db_object.dart';

class LocalCapture extends AbstractLocalDbObject {
  final String _captureID;
  final String _path;

  LocalCapture({
    int? id,
    required String captureID,
    required String path
  }): _captureID = captureID, _path = path;

  get captureID {
    return _captureID;
  }

  get path {
    return _path;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'captureID': _captureID,
      'path': _path,
    };
  }

  @override
  String toString() {
    return 'DeviceName{id: $id, captureID: $_captureID, path: $_path}';
  }
}