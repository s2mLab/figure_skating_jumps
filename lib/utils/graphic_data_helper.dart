import 'dart:math';

import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/models/graphic_data_classes/graph_stats_date_pair.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:figure_skating_jumps/services/graph_date_preferences_service.dart';

class GraphicDataHelper {

  static Future<Map<JumpType, List<GraphStatsDatePair>>>
      getJumpScorePerTypeGraphData(Map<String, List<Capture>> captures) async {
    Map<JumpType, List<GraphStatsDatePair>> mappedJumps = {};
    for (JumpType type in JumpType.values) {
      mappedJumps[type] = await _getJumpScorePerType(captures, type);
    }
    return mappedJumps;
  }

  static Future<List<GraphStatsDatePair>> getAverageFlyTimeGraphData(
      Map<String, List<Capture>> captures) async {
    List<GraphStatsDatePair> graphData = [];
    List<String> dates = _getAllDates(captures);
    for (String day in dates) {
      GraphStatsDatePair? pair = await _getAverageJumpDurationOnDate(captures, day);
      if(pair == null) continue;
      graphData.add(pair);
    }
    return graphData;
  }

  static List<String> _getAllDates(Map<String, List<Capture>> captures) {
    List<String> dates = captures.keys.toList();
    dates.removeWhere((element) => DateTime.parse(element).isBefore(GraphDatePreferencesService.begin) || DateTime.parse(element).isAfter(GraphDatePreferencesService.end));
    return dates;
  }

  static Future<GraphStatsDatePair?> _getAverageJumpScorePerTypeOnDate(
      Map<String, List<Capture>> captures, String day, JumpType type) async {
    if (captures[day] == null || captures[day]!.isEmpty) {
      throw ArgumentError('captures at date was null or empty');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfType = await _getRequiredJumpsFromCaptures(
        capturesOnDate, (jump) => jump.type == type);
    List<int> scoresOfJumps = [];
    for (Jump j in jumpsOfType) {
      scoresOfJumps.add(j.score);
    }
    DateTime statDay = DateTime.parse(day);
    return scoresOfJumps.isEmpty ? null : GraphStatsDatePair(scoresOfJumps.average, _standardDeviation(scoresOfJumps), scoresOfJumps.min, scoresOfJumps.max, statDay);
  }

  static double _standardDeviation(List<int> list) {
    final double mean = list.average;
    final List<num> squaredDiffs = list.map((x) => pow(x - mean, 2)).toList();
    final double variance = squaredDiffs.sum / squaredDiffs.length;
    return sqrt(variance);
  }

  static Future<GraphStatsDatePair?> _getAverageJumpDurationOnDate(
      Map<String, List<Capture>> captures, String day) async {
    if (captures[day] == null || captures[day]!.isEmpty) {
      throw ArgumentError('captures at date was null or empty');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfDate =
        await _getRequiredJumpsFromCaptures(capturesOnDate);
    List<int> durationsOfJumps = [];
    for (Jump j in jumpsOfDate) {
      durationsOfJumps.add(j.duration);
    }
    DateTime statDay = DateTime.parse(day);
    return durationsOfJumps.isEmpty ? null : GraphStatsDatePair(durationsOfJumps.average, _standardDeviation(durationsOfJumps), durationsOfJumps.min, durationsOfJumps.max, statDay);
  }

  static Future<List<Jump>> _getRequiredJumpsFromCaptures(
      List<Capture> captures,
      [bool Function(Jump)? test]) async {
    List<Jump> jumps = [];
    List<Jump> captureJumps;
    for (Capture capture in captures) {
      captureJumps = await capture.getJumpsData();
      jumps.addAll(test == null ? captureJumps : captureJumps.where(test));
    }
    return jumps;
  }

  static Future<List<GraphStatsDatePair>> _getJumpScorePerType(
      Map<String, List<Capture>> captures, JumpType type) async {
    List<GraphStatsDatePair> graphData = [];
    List<String> dates = _getAllDates(captures);
    for (String day in dates) {
      GraphStatsDatePair? pair =
          await _getAverageJumpScorePerTypeOnDate(captures, day, type);
      if(pair == null) continue;
      graphData.add(pair);
    }
    return graphData;
  }
}
