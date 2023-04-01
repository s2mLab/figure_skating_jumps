import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:figure_skating_jumps/models/modification.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';

import '../enums/season.dart';

class Capture {
  late String? uID;
  late String _file;
  late String _userID;
  late int _duration;
  late DateTime _date;
  late List<String> _jumpsID;
  late bool _hasVideo;
  late List<Modification> _modifications;
  final List<Jump> _jumps = [];
  final Season _season;
  final Map<JumpType, int> _jumpTypeCount = {
    JumpType.axel: 0,
    JumpType.flip: 0,
    JumpType.loop: 0,
    JumpType.lutz: 0,
    JumpType.salchow: 0,
    JumpType.toeLoop: 0,
    JumpType.unknown: 0,
  };

  String get fileName {
    return _file;
  }

  Season get season {
    return _season;
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

  bool get hasVideo {
    return _hasVideo;
  }

  List<Jump> get jumps {
    return _jumps;
  }

  List<String> get jumpsID {
    return _jumpsID;
  }

  List<Modification> get modifications {
    return _modifications;
  }

  List<Map> get modsAsMap {
    List<Map> modsList = [];
    for (Modification mods in _modifications) {
      modsList.add({'action': mods.action, 'date': mods.date});
    }
    return modsList;
  }

  Map<JumpType, int> get jumpTypeCount {
    return _jumpTypeCount;
  }

  Capture(
      this._file, this._userID, this._duration, this._hasVideo, this._date, this._season, this._jumpsID, this._modifications,
      [this.uID]);

  factory Capture._fromFirestore(
      String? uID, DocumentSnapshot<Map<String, dynamic>> captureInfo) {
    return Capture(
        captureInfo.get('file'),
        captureInfo.get('user'),
        captureInfo.get('duration'),
        captureInfo.get('hasVideo'),
        (captureInfo.get('date') as Timestamp).toDate(),
        Season.values.firstWhere((element) => element.displayedString == captureInfo.get('season')),
        List<String>.from(captureInfo.get('jumps') as List),
        List<Modification>.from((captureInfo.get('modifications') as List)
            .map((element) => Modification.buildFromMap(element))),
        uID);
  }

  static void sortJumps(Capture c) {
    c._jumps.sort((a, b) => a.time.compareTo(b.time));
  }

  static Future<Capture> createFromFirebase(
      String? uID, DocumentSnapshot<Map<String, dynamic>> captureInfo) async {
    Capture capture = Capture._fromFirestore(uID, captureInfo);
    for (String jumpID in capture._jumpsID) {
      Jump jumpToAdd = await CaptureClient().getJumpByID(uID: jumpID);
      capture.jumpTypeCount[jumpToAdd.type] =
          capture.jumpTypeCount[jumpToAdd.type]! + 1;
      capture._jumps.add(jumpToAdd);
      Capture.sortJumps(capture);
    }

    return capture;
  }
}
