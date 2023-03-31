import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/models/graphic_data_classes/value_date_pair.dart';

import '../enums/jump_type.dart';
import '../models/capture.dart';
import '../models/jump.dart';

class GraphicDataHelper {

  static List<ValueDatePair> getJumpScorePerTypeGraphData(Map<String, List<Capture>> captures, JumpType type) {
    List<ValueDatePair> graphData = [];
    List<String> dates = getAllDates(captures);
    for(String day in dates) {
      double? score = getAverageJumpScorePerTypeOnDate(captures, day, type);
      if(score != null) graphData.add(ValueDatePair(score, day));
    }
    return graphData;
  }

  static List<String> getAllDates(Map<String, List<Capture>> captures) {
    return captures.keys.toList();
  }

  static double? getAverageJumpScorePerTypeOnDate(Map<String, List<Capture>> captures, String day, JumpType type) {
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

  static double getPercentageOfSuccessfulJumpsOnDate(Map<String, List<Capture>> captures, String day, JumpType type) {
    if(captures[day] == null || captures[day]!.isEmpty) {
      throw ArgumentError('captures at date was null or empty');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfDate = _getRequiredJumpsFromCaptures(capturesOnDate);
    // Jumps are considered a success if the score is one or more.
    List<Jump> succeededJumps = jumpsOfDate.where((element) => element.score > 0).toList();
    return succeededJumps.length / (jumpsOfDate.length * 100.0);
  }

  static double getAverageJumpDurationOnDate(Map<String, List<Capture>> captures, String day, JumpType type) {
    if(captures[day] == null || captures[day]!.isEmpty) {
      throw ArgumentError('captures at date was null or empty');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfDate = _getRequiredJumpsFromCaptures(capturesOnDate);
    // Jumps are considered a success if the score is one or more.
    List<Jump> succeededJumps = jumpsOfDate.where((element) => element.score > 0).toList();
    return succeededJumps.length / (jumpsOfDate.length * 100.0);
  }

  static List<Jump> _getRequiredJumpsFromCaptures(List<Capture> captures, [bool Function(Jump)? test]) {
    List<Jump> jumps = [];
    for (Capture c in captures) {
      jumps.addAll(test == null ? c.jumps : c.jumps.where(test));
    }
    return jumps;
  }
}