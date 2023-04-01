import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/models/graphic_data_classes/value_date_pair.dart';

import '../enums/jump_type.dart';
import '../models/capture.dart';
import '../models/jump.dart';

class GraphicDataHelper {

  static List<ValueDatePair> getJumpScorePerTypeGraphData(Map<String, List<Capture>> captures, JumpType type) {
    List<ValueDatePair> graphData = [];
    List<String> dates = _getAllDates(captures);
    for(String day in dates) {
      double? score = _getAverageJumpScorePerTypeOnDate(captures, day, type);
      graphData.add(ValueDatePair(score, day));
    }
    return graphData;
  }

  static List<ValueDatePair> getPercentageSucceededGraphData(Map<String, List<Capture>> captures) {
    List<ValueDatePair> graphData = [];
    List<String> dates = _getAllDates(captures);
    for(String day in dates) {
      double? percentage = _getPercentageOfSuccessfulJumpsOnDate(captures, day);
      graphData.add(ValueDatePair(percentage, day));
    }
    return graphData;
  }

  static List<ValueDatePair> getAverageFlyTimeGraphData(Map<String, List<Capture>> captures) {
    List<ValueDatePair> graphData = [];
    List<String> dates = _getAllDates(captures);
    for(String day in dates) {
      double? flyTime = _getAverageJumpDurationOnDate(captures, day);
      graphData.add(ValueDatePair(flyTime, day));
    }
    return graphData;
  }

  static List<String> _getAllDates(Map<String, List<Capture>> captures) {
    return captures.keys.toList();
  }

  static double? _getAverageJumpScorePerTypeOnDate(Map<String, List<Capture>> captures, String day, JumpType type) {
    if(captures[day] == null || captures[day]!.isEmpty) {
      throw ArgumentError('captures at date was null or empty');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfType = _getRequiredJumpsFromCaptures(capturesOnDate, (jump) => jump.type==type);
    List<int> scoresOfJumps = [];
    for(Jump j in jumpsOfType) {
      scoresOfJumps.add(j.score);
    }
    return scoresOfJumps.isEmpty ? null : scoresOfJumps.average;
  }

  static double? _getPercentageOfSuccessfulJumpsOnDate(Map<String, List<Capture>> captures, String day) {
    if(captures[day] == null || captures[day]!.isEmpty) {
      throw ArgumentError('captures at date was null or empty');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfDate = _getRequiredJumpsFromCaptures(capturesOnDate);
    // Jumps are considered a success if the score is one or more.
    List<Jump> succeededJumps = jumpsOfDate.where((element) => element.score > 0).toList();
    return jumpsOfDate.isEmpty ? null : (succeededJumps.length * 1.0 / jumpsOfDate.length) * 100.0;
  }

  static double? _getAverageJumpDurationOnDate(Map<String, List<Capture>> captures, String day) {
    if(captures[day] == null || captures[day]!.isEmpty) {
      throw ArgumentError('captures at date was null or empty');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfDate = _getRequiredJumpsFromCaptures(capturesOnDate);
    List<int> durationsOfJumps = [];
    for(Jump j in jumpsOfDate) {
      durationsOfJumps.add(j.duration);
    }
    return durationsOfJumps.isEmpty ? null : durationsOfJumps.average;
  }

  static List<Jump> _getRequiredJumpsFromCaptures(List<Capture> captures, [bool Function(Jump)? test]) {
    List<Jump> jumps = [];
    for (Capture c in captures) {
      jumps.addAll(test == null ? c.jumps : c.jumps.where(test));
    }
    return jumps;
  }
}