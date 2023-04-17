import 'dart:math';

import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/enums/models/jump_type.dart';
import 'package:figure_skating_jumps/models/firebase/capture.dart';
import 'package:figure_skating_jumps/models/graph_stats_date_pair.dart';
import 'package:figure_skating_jumps/models/firebase/jump.dart';
import 'package:figure_skating_jumps/utils/graph_date_preferences_utils.dart';

class GraphicDataHelper {
  /// Returns a map of JumpType to a list of GraphStatsDatePair for each JumpType,
  /// calculated from the given [captures] data.
  ///
  /// This function iterates over each JumpType and calls [_getJumpScorePerType]
  /// with the given [captures] data to calculate the corresponding GraphStatsDatePair.
  ///
  /// Returns a Future<Map<JumpType, List<GraphStatsDatePair>>> that maps each JumpType to
  /// its corresponding list of GraphStatsDatePair.
  static Future<Map<JumpType, List<GraphStatsDatePair>>>
      getJumpScorePerTypeGraphData(Map<String, List<Capture>> captures) async {
    Map<JumpType, List<GraphStatsDatePair>> mappedJumps = {};
    for (JumpType type in JumpType.values) {
      mappedJumps[type] = await _getJumpScorePerType(captures, type);
    }
    return mappedJumps;
  }

  /// Retrieves a list of graph data representing the average fly time per day
  /// from a map of captures, where the key is a date string and the value is a list
  /// of jump [Capture]s for that day.
  ///
  /// The function iterates over each date in the map, retrieves the average fly time
  /// for that day using [_getAverageJumpDurationOnDate] and adds the result to
  /// a list of [GraphStatsDatePair]s, which is returned by the function.
  ///
  /// The returned [GraphStatsDatePair]s represent the average fly time and date
  /// for each day in the input [captures] map.
  static Future<List<GraphStatsDatePair>> getAverageFlyTimeGraphData(
      Map<String, List<Capture>> captures) async {
    List<GraphStatsDatePair> graphData = [];
    List<String> dates = _getAllDates(captures);
    for (String day in dates) {
      GraphStatsDatePair? pair =
          await _getAverageJumpDurationOnDate(captures, day);
      if (pair == null) continue;
      graphData.add(pair);
    }
    return graphData;
  }

  /// Retrieves all dates within the date range specified in [GraphDatePreferencesUtils].
  ///
  /// This function takes a [Map] of [String] and [List] of [Capture] as input, and returns
  /// a [List] of [String] representing all the dates within the date range specified in
  /// [GraphDatePreferencesUtils]. Dates that fall outside the date range are removed from
  /// the returned list.
  ///
  /// Returns a [List] of [String] representing all the dates within the date range specified
  /// in [GraphDatePreferencesUtils].
  static List<String> _getAllDates(Map<String, List<Capture>> captures) {
    List<String> dates = captures.keys.toList();
    dates.removeWhere((element) =>
        DateTime.parse(element).isBefore(GraphDatePreferencesUtils.begin) ||
        DateTime.parse(element).isAfter(GraphDatePreferencesUtils.end));
    return dates;
  }

  /// Calculates and returns average jump score statistics for a given JumpType and date.
  ///
  /// This function takes a [Map] of [String] keys (representing dates) and [List] of [Capture] values,
  /// along with a [String] representing a date and a [JumpType]. It retrieves all jumps of the given type
  /// on the given date, calculates the average score, standard deviation, minimum, and maximum score of those jumps,
  /// and returns those values wrapped in a [GraphStatsDatePair] object.
  ///
  /// If no jumps of the given type are found on the given date, returns `null`.
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
    return scoresOfJumps.isEmpty
        ? null
        : GraphStatsDatePair(
            scoresOfJumps.average,
            _standardDeviation(scoresOfJumps),
            scoresOfJumps.min,
            scoresOfJumps.max,
            statDay);
  }

  /// Calculates the standard deviation of a list of integers.
  ///
  /// Calculates the mean of the input list, then calculates the variance using the
  /// squared differences of each item from the mean. The variance is then square rooted
  /// to get the standard deviation.
  ///
  /// Returns a [double] value representing the standard deviation of the input list.
  static double _standardDeviation(List<int> list) {
    final double mean = list.average;
    final List<num> squaredDiffs = list.map((x) => pow(x - mean, 2)).toList();
    final double variance = squaredDiffs.sum / squaredDiffs.length;
    return sqrt(variance);
  }

  /// Retrieves the average jump duration for a given day, based on a map of captures.
  ///
  /// This function takes a [Map] of [String] keys and [List] values representing captures of jumps for a set of days,
  /// and a [String] representing the day for which to retrieve the average jump duration.
  ///
  /// Returns a [Future] that completes with a [GraphStatsDatePair] object containing information about the average jump duration,
  /// including the mean, standard deviation, minimum, maximum, and date of the statistics calculation. Returns `null` if no jumps
  /// were found on the specified date.
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
    return durationsOfJumps.isEmpty
        ? null
        : GraphStatsDatePair(
            durationsOfJumps.average,
            _standardDeviation(durationsOfJumps),
            durationsOfJumps.min,
            durationsOfJumps.max,
            statDay);
  }

  /// Retrieves a list of jumps from a list of captures that meet the specified test criteria.
  ///
  /// This function takes a [List] of [Capture] objects and an optional [bool Function] test parameter,
  /// which is used to filter the jumps that are retrieved from the captures. If no test is provided,
  /// all jumps will be included.
  ///
  /// Returns a [Future] that completes with a [List] of [Jump] objects that meet the specified test criteria.
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

  /// Retrieves the jump score per type for a given set of captures, based on the specified [JumpType].
  ///
  /// This function takes a [Map] of [String] keys and [List] values representing captures of jumps for a set of days,
  /// and a [JumpType] parameter representing the type of jump for which to retrieve scores.
  ///
  /// Returns a [Future] that completes with a [List] of [GraphStatsDatePair] objects containing information about the
  /// jump score per type, including the mean, standard deviation, minimum, maximum, and date of the statistics calculation.
  static Future<List<GraphStatsDatePair>> _getJumpScorePerType(
      Map<String, List<Capture>> captures, JumpType type) async {
    List<GraphStatsDatePair> graphData = [];
    List<String> dates = _getAllDates(captures);
    for (String day in dates) {
      GraphStatsDatePair? pair =
          await _getAverageJumpScorePerTypeOnDate(captures, day, type);
      if (pair == null) continue;
      graphData.add(pair);
    }
    return graphData;
  }
}
