import 'package:cloud_firestore/cloud_firestore.dart';

class Capture {
  late String? uID;
  late String _file;
  late String _userID;
  late int _duration;
  late DateTime _date;
  late List<String> _jumps;

  String get fileName {
    return _file;
  }

  String get userID {
    return _userID;
  }

  int get duration {
    return _duration;
  }

  DateTime get date {
    return _date;
  }

  List<String> get jumps {
    return _jumps;
  }

  Capture(this._file, this._userID);

  Capture.fromJumps(
      this._file, this._userID, this._duration, this._date, this._jumps,
      [this.uID]);

  factory Capture.fromFirestore(
      uID, DocumentSnapshot<Map<String, dynamic>> userInfo) {
    String file = userInfo.get('file');
    String user = userInfo.get('user');
    int duration = userInfo.get('duration');
    DateTime date = (userInfo.get('date') as Timestamp).toDate();
    //DateTime date = DateTime.fromMillisecondsSinceEpoch(userInfo.get('date'));
    List<String> jumps = List<String>.from(userInfo.get('jumps') as List);

    return Capture.fromJumps(file, user, duration, date, jumps, uID);
  }
}
