import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/models/jump.dart';

class Capture {
  static const String _jumpsCollectionString = 'jumps';

  late String? uID;
  late String _file;
  late String _userID;
  late int _duration;
  late DateTime _date;
  late List<String> _jumpsID;
  final List<Jump> _jumps = [];
  final List<int> _jumpTypeCount = [0, 0, 0, 0, 0, 0];

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

  List<Jump> get jumps {
    return _jumps;
  }

  List<int> get jumpTypeCount {
    return _jumpTypeCount;
  }

  Capture(this._file, this._userID);

  Capture.fromJumps(
      this._file, this._userID, this._duration, this._date, this._jumpsID,
      [this.uID]);

  factory Capture.fromFirestore(
      uID, DocumentSnapshot<Map<String, dynamic>> userInfo) {
    String file = userInfo.get('file');
    String user = userInfo.get('user');
    int duration = userInfo.get('duration');
    DateTime date = (userInfo.get('date') as Timestamp).toDate();
    List<String> jumpsID = List<String>.from(userInfo.get('jumps') as List);

    return Capture.fromJumps(file, user, duration, date, jumpsID, uID);
  }

  static Future<Capture> create(
      uID, DocumentSnapshot<Map<String, dynamic>> userInfo) async {
    Capture capture = Capture.fromFirestore(uID, userInfo);

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    for (String jumpID in capture._jumpsID) {
      Jump jumpToAdd = Jump.fromFirestore(jumpID,
          await firestore.collection(_jumpsCollectionString).doc(jumpID).get());
      capture._jumpTypeCount[jumpToAdd.type.index]++;
      capture._jumps.add(jumpToAdd);
    }

    return capture;
  }
}
