import 'dart:math';

import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/models/graphic_data_classes/value_date_pair.dart';
import 'package:flutter/cupertino.dart';

import '../enums/jump_type.dart';
import '../models/capture.dart';
import '../models/jump.dart';

class GraphicDataHelper {

  static List<GraphStatsDatePair> getJumpScorePerTypeGraphData(Map<String, List<Capture>> captures, JumpType type) {
    List<GraphStatsDatePair> graphData = [];
    List<String> dates = _getAllDates(captures);
    for(String day in dates) {
      GraphStatsDatePair? pair = _getAverageJumpScorePerTypeOnDate(captures, day, type);
      if(pair == null) continue;
      graphData.add(pair);
    }
    return graphData;
  }

  static List<GraphStatsDatePair> getAverageFlyTimeGraphData(Map<String, List<Capture>> captures) {
    List<GraphStatsDatePair> graphData = [];
    List<String> dates = _getAllDates(captures);
    for(String day in dates) {
      GraphStatsDatePair? pair = _getAverageJumpDurationOnDate(captures, day);
      if(pair == null) continue;
      graphData.add(pair);
    }
    return graphData;
  }

  static List<String> _getAllDates(Map<String, List<Capture>> captures) {
    return captures.keys.toList();
  }

  static GraphStatsDatePair? _getAverageJumpScorePerTypeOnDate(Map<String, List<Capture>> captures, String day, JumpType type) {
    if(captures[day] == null || captures[day]!.isEmpty) {
      throw ArgumentError('captures at date was null or empty');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfType = _getRequiredJumpsFromCaptures(capturesOnDate, (jump) => jump.type==type);
    List<int> scoresOfJumps = [];
    for(Jump j in jumpsOfType) {
      scoresOfJumps.add(j.score);
    }
    DateTime statDay = DateTime.parse(day);
    debugPrint("original $day parsed $statDay");
    return scoresOfJumps.isEmpty ? null : GraphStatsDatePair(scoresOfJumps.average, _standardDeviation(scoresOfJumps), scoresOfJumps.min, scoresOfJumps.max, statDay);
  }

  static double _standardDeviation(List<int> list) {
    final double mean = list.average;
    final List<num> squaredDiffs = list.map((x) => pow(x - mean, 2)).toList();
    final double variance = squaredDiffs.sum / squaredDiffs.length;
    return sqrt(variance);
  }

  static GraphStatsDatePair? _getAverageJumpDurationOnDate(Map<String, List<Capture>> captures, String day) {
    if(captures[day] == null || captures[day]!.isEmpty) {
      throw ArgumentError('captures at date was null or empty');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfDate = _getRequiredJumpsFromCaptures(capturesOnDate);
    List<int> durationsOfJumps = [];
    for(Jump j in jumpsOfDate) {
      durationsOfJumps.add(j.duration);
    }
    DateTime statDay = DateTime.parse(day);
    debugPrint("original $day parsed $statDay");
    return durationsOfJumps.isEmpty ? null : GraphStatsDatePair(durationsOfJumps.average, _standardDeviation(durationsOfJumps), durationsOfJumps.min, durationsOfJumps.max, statDay);
  }

  static List<Jump> _getRequiredJumpsFromCaptures(List<Capture> captures, [bool Function(Jump)? test]) {
    List<Jump> jumps = [];
    for (Capture c in captures) {
      jumps.addAll(test == null ? c.jumps : c.jumps.where(test));
    }
    return jumps;
  }
}