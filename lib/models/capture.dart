import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/enums/season.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:figure_skating_jumps/models/modification.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';

class Capture {
  late String? uID;
  late int _duration;
  late bool _hasVideo;
  late String _file;
  late String _userID;
  late DateTime _date;
  final Season _season;
  late List<String> _jumpsID;
  late List<Modification> _modifications;

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

  Capture(this._file, this._userID, this._duration, this._hasVideo, this._date,
      this._season, this._jumpsID, this._modifications,
      [this.uID]);

  factory Capture.fromFirestore(
      String? uID, DocumentSnapshot<Map<String, dynamic>> captureInfo) {
    return Capture(
        captureInfo.get('file'),
        captureInfo.get('user'),
        captureInfo.get('duration'),
        captureInfo.get('hasVideo'),
        (captureInfo.get('date') as Timestamp).toDate(),
        Season.values.firstWhere(
            (element) => element.toString() == captureInfo.get('season')),
        List<String>.from(captureInfo.get('jumps') as List),
        List<Modification>.from((captureInfo.get('modifications') as List)
            .map((element) => Modification.buildFromMap(element))),
        uID);
  }

  Future<List<Jump>> getJumpsData() async {
    List<Jump> jumps = [];
    for (String id in _jumpsID) {
      jumps.add(await CaptureClient().getJumpByID(uID: id));
    }
    return jumps;
  }

  static Map<JumpType, int> getJumpTypeCount(List<Jump> jumps) {
    Map<JumpType, int> jumpTypeCount = {};
    for (JumpType type in JumpType.values) {
      jumpTypeCount[type] = 0;
    }

    for (Jump jump in jumps) {
      jumpTypeCount[jump.type] = jumpTypeCount[jump.type]! + 1;
    }

    return jumpTypeCount;
  }
}
