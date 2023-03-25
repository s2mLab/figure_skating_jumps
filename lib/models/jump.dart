import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:flutter/cupertino.dart';

class Jump {
  late String? uID;
  late int _time;
  late int _duration;
  late double _turns;
  late JumpType _type;
  late String _captureID;
  late String _comment;
  late double _score;
  late double _rotationDegrees;
  late double _maxRotationSpeed;
  late double _durationToMaxSpeed;

  double get rotationDegrees {
    return _rotationDegrees;
  }

  double get maxRotationSpeed {
    return _maxRotationSpeed;
  }

  double get durationToMaxSpeed {
    return _durationToMaxSpeed;
  }

  int get time {
    return _time;
  }

  int get duration {
    return _duration;
  }

  double get turns {
    return _turns;
  }

  JumpType get type {
    return _type;
  }

  String get comment {
    return _comment;
  }

  double get score {
    return _score;
  }

  String get captureID {
    return _captureID;
  }

  Jump(
      this._time,
      this._duration,
      this._turns,
      this._type,
      this._comment,
      this._score,
      this._captureID,
      this._durationToMaxSpeed,
      this._maxRotationSpeed,
      this._rotationDegrees,
      [this.uID]);

  factory Jump.fromFirestore(
      uID, DocumentSnapshot<Map<String, dynamic>> jumpInfo) {
    try {
      int time = jumpInfo.get('time');
      int duration = jumpInfo.get('duration');
      double turns = double.parse(jumpInfo.get('turns').toString());
      String capture = jumpInfo.get('capture');
      String comment = jumpInfo.get('comment');
      double score = double.parse(jumpInfo.get('score').toString());
      double durationToMaxSpeed = double.parse(jumpInfo.get('durationToMaxSpeed').toString());
      double maxRotationSpeed = double.parse(jumpInfo.get('maxSpeed').toString());
      double rotationDegrees = double.parse(jumpInfo.get('rotation').toString());

      String typeStr = jumpInfo.get('type');
      JumpType type =
      JumpType.values.firstWhere((element) => element.toString() == typeStr);

      return Jump(time, duration, turns, type, comment, score, capture,
          durationToMaxSpeed, maxRotationSpeed, rotationDegrees, uID);

    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }


  }
}
