import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';

class Jump {
  late String? uID;
  late int _time;
  late int _duration;
  late double _turns;
  late JumpType type;
  late String _capture;

  int get time {
    return _time;
  }

  int get duration {
    return _duration;
  }

  double get turns {
    return _turns;
  }

  String get capture {
    return _capture;
  }

  Jump(this._time, this._duration, this._turns, this.type, this._capture,
      [this.uID]);

  factory Jump.fromFirestore(
      uID, DocumentSnapshot<Map<String, dynamic>> userInfo) {
    int time = userInfo.get('time');
    int duration = userInfo.get('duration');
    double turns = userInfo.get('turns');
    String capture = userInfo.get('capture');

    String typeStr = userInfo.get('type');
    JumpType type =
        JumpType.values.firstWhere((element) => element.toString() == typeStr);

    return Jump(time, duration, turns, type, capture, uID);
  }
}
