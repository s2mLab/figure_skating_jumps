import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/models/graphic_data_classes/value_date_pair.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';

import '../enums/jump_type.dart';
import '../models/capture.dart';
import '../models/jump.dart';

class GraphicDataHelper {
  static Future<Map<JumpType, List<ValueDatePair>>> getJumpScorePerTypeGraphData(Map<String, List<Capture>> captures) async {
    Map<JumpType, List<ValueDatePair>> mappedJumps = {};
    for (JumpType type in JumpType.values) {
      mappedJumps[type] = await _getJumpScorePerType(captures, type);
    }
    return mappedJumps;
  }

  static Future<List<ValueDatePair>> getPercentageSucceededGraphData(Map<String, List<Capture>> captures) async {
    List<ValueDatePair> graphData = [];
    List<String> dates = _getAllDates(captures);
    for(String day in dates) {
      double? percentage = await _getPercentageOfSuccessfulJumpsOnDate(captures, day);
      graphData.add(ValueDatePair(percentage, day));
    }
    return graphData;
  }

  static Future<List<ValueDatePair>> getAverageFlyTimeGraphData(Map<String, List<Capture>> captures) async {
    List<ValueDatePair> graphData = [];
    List<String> dates = _getAllDates(captures);
    for(String day in dates) {
      double? flyTime = await _getAverageJumpDurationOnDate(captures, day);
      graphData.add(ValueDatePair(flyTime, day));
    }
    return graphData;
  }

  static List<String> _getAllDates(Map<String, List<Capture>> captures) {
    return captures.keys.toList();
  }

  static Future<double?> _getAverageJumpScorePerTypeOnDate(Map<String, List<Capture>> captures, String day, JumpType type) async {
    if(captures[day] == null || captures[day]!.isEmpty) {
      throw ArgumentError('captures at date was null or empty');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfType = await _getRequiredJumpsFromCaptures(capturesOnDate, (jump) => jump.type==type);
    List<int> scoresOfJumps = [];
    for(Jump j in jumpsOfType) {
      scoresOfJumps.add(j.score);
    }
    return scoresOfJumps.isEmpty ? null : scoresOfJumps.average;
  }

  static Future<double?> _getPercentageOfSuccessfulJumpsOnDate(Map<String, List<Capture>> captures, String day) async {
    if(captures[day] == null || captures[day]!.isEmpty) {
      throw ArgumentError('captures at date was null or empty');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfDate = await _getRequiredJumpsFromCaptures(capturesOnDate);
    // Jumps are considered a success if the score is one or more.
    List<Jump> succeededJumps = jumpsOfDate.where((element) => element.score > 0).toList();
    return jumpsOfDate.isEmpty ? null : (succeededJumps.length * 1.0 / jumpsOfDate.length) * 100.0;
  }

  static Future<double?> _getAverageJumpDurationOnDate(Map<String, List<Capture>> captures, String day) async {
    if(captures[day] == null || captures[day]!.isEmpty) {
      throw ArgumentError('captures at date was null or empty');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfDate = await _getRequiredJumpsFromCaptures(capturesOnDate);
    List<int> durationsOfJumps = [];
    for(Jump j in jumpsOfDate) {
      durationsOfJumps.add(j.duration);
    }
    return durationsOfJumps.isEmpty ? null : durationsOfJumps.average;
  }

  static Future<List<Jump>> _getRequiredJumpsFromCaptures(List<Capture> captures, [bool Function(Jump)? test]) async {
    List<Jump> jumps = [];
    List<Jump> captureJumps;
    for (Capture capture in captures) {
      captureJumps = [];
      for (String id in capture.jumpsID) {
        captureJumps.add(await CaptureClient().getJumpByID(uID: id));
      }
      jumps.addAll(test == null ? captureJumps : captureJumps.where(test));
    }
    return jumps;
  }

  static Future<List<ValueDatePair>> _getJumpScorePerType(Map<String, List<Capture>> captures, JumpType type) async {
    List<ValueDatePair> graphData = [];
    List<String> dates = _getAllDates(captures);
    for(String day in dates) {
      double? score = await _getAverageJumpScorePerTypeOnDate(captures, day, type);
      graphData.add(ValueDatePair(score, day));
    }
    return graphData;
  }
}