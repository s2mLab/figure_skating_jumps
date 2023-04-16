import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/constants/jump_scores.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:flutter/cupertino.dart';

class Jump {
  static const degreesPerTurn = 360;
  late String? uID;
  late int _time;
  late int _duration; //maybe change to double
  late bool isCustom;
  late JumpType type;
  late String _captureID;
  late String comment;
  late int _score;
  late double _rotationDegrees;
  late double _maxRotationSpeed;
  late double _durationToMaxSpeed;

  double get rotationDegrees {
    return _rotationDegrees;
  }

  set rotationDegrees(double value) {
    _rotationDegrees = value < 0 ? 0 : value;
  }

  double get maxRotationSpeed {
    return _maxRotationSpeed;
  }

  set maxRotationSpeed(double value) {
    _maxRotationSpeed = _maxRotationSpeed.abs();
  }

  double get durationToMaxSpeed {
    return _durationToMaxSpeed;
  }

  set durationToMaxSpeed(double value) {
    _durationToMaxSpeed = value < 0 ? 0 : value;
  }

  int get time {
    return _time;
  }

  set time(int value) {
    _time = value < 0 ? 0 : value;
  }

  int get duration {
    return _duration;
  }

  set duration(int value) {
    _duration = value < 0 ? 0 : value;
  }

  double get turns {
    return _rotationDegrees / degreesPerTurn;
  }

  set turns(double value) {
    _rotationDegrees = value < 0 ? 0 : value * degreesPerTurn;
  }

  int get score {
    return _score;
  }

  set score(value){
    if(!jumpScores.contains(value) && value != null) {
      throw ArgumentError("Score is not in accepted values");
    }
    _score = value;
  }

  String get captureID {
    return _captureID;
  }

  Jump(
      this._time,
      this._duration,
      this.isCustom,
      this.type,
      this.comment,
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
      bool isCustom = jumpInfo.get('isCustom');
      String capture = jumpInfo.get('capture');
      String comment = jumpInfo.get('comment');
      int score = int.parse(jumpInfo.get('score').toString());
      double durationToMaxSpeed = double.parse(jumpInfo.get('durationToMaxSpeed').toString());
      double maxRotationSpeed = double.parse(jumpInfo.get('maxSpeed').toString());
      double rotationDegrees = double.parse(jumpInfo.get('rotation').toString());

      String typeStr = jumpInfo.get('type');
      JumpType type =
      JumpType.values.firstWhere((element) => element.toString() == typeStr);

      return Jump(time, duration, isCustom, type, comment, score, capture,
          durationToMaxSpeed, maxRotationSpeed, rotationDegrees, uID);

    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
