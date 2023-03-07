import 'package:cloud_firestore/cloud_firestore.dart';

class Capture {
  late String? uID;
  late String _file;
  late String _userID;

  String get fileName {
    return _file;
  }

  String get userID {
    return _userID;
  }

  Capture(this._file, this._userID);

  Capture.fromFirestore(
      this.uID, DocumentSnapshot<Map<String, dynamic>> userInfo) {
    String file = userInfo.get('file');
    String user = userInfo.get('user');

    Capture(file, user);
  }
}