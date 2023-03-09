import 'package:cloud_firestore/cloud_firestore.dart';

class Capture {
  late String? uID;
  late String _file;
  late String _userID;
  late List<String> _jumps;

  String get fileName {
    return _file;
  }

  String get userID {
    return _userID;
  }

  List<String> get jumps {
    return _jumps;
  }

  Capture(this._file, this._userID);

  Capture.fromJumps(this._file, this._userID, this._jumps, [this.uID]);

  factory Capture.fromFirestore(
      uID, DocumentSnapshot<Map<String, dynamic>> userInfo) {
    String file = userInfo.get('file');
    String user = userInfo.get('user');
    List<dynamic> jmp = userInfo.get('jumps');
    List<String> jumps = jmp.map((e) => e as String).toList();

    return Capture.fromJumps(file, user, jumps, uID);
  }
}