import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
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
  final Map<JumpType, int> _jumpTypeCount = {
    JumpType.axel: 0,
    JumpType.flip: 0,
    JumpType.loop: 0,
    JumpType.lutz: 0,
    JumpType.salchow: 0,
    JumpType.toeLoop: 0,
    JumpType.unknown : 0,
  };

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

  List<String> get jumpsID {
    return _jumpsID;
  }

    Map<JumpType, int> get jumpTypeCount {
    return _jumpTypeCount;
  }

  Capture(
      this._file, this._userID, this._duration, this._date, this._jumpsID,
      [this.uID]);

  factory Capture._fromFirestore(
      String? uID, DocumentSnapshot<Map<String, dynamic>> captureInfo) {
    return Capture(
        captureInfo.get('file'),
        captureInfo.get('user'),
        captureInfo.get('duration'),
        (captureInfo.get('date') as Timestamp).toDate(),
        List<String>.from(captureInfo.get('jumps') as List),
        uID);
  }

  static Future<Capture> createFromFireBase(
      String? uID, DocumentSnapshot<Map<String, dynamic>> captureInfo) async {
    Capture capture = Capture._fromFirestore(uID, captureInfo);

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    for (String jumpID in capture._jumpsID) {
      Jump jumpToAdd = Jump.fromFirestore(jumpID,
          await firestore.collection(_jumpsCollectionString).doc(jumpID).get());
      capture.jumpTypeCount[jumpToAdd.type] =
          capture.jumpTypeCount[jumpToAdd.type]! + 1;
      capture._jumps.add(jumpToAdd);
    }

    return capture;
  }
}
