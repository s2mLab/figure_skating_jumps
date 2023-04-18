import 'dart:math';

import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/enums/models/jump_type.dart';
import 'package:figure_skating_jumps/models/firebase/capture.dart';
import 'package:figure_skating_jumps/models/graph_stats_date_pair.dart';
import 'package:figure_skating_jumps/models/firebase/jump.dart';
import 'package:figure_skating_jumps/utils/graph_date_preferences_utils.dart';

class GraphicDataHelper {
  /// Returns a Future that resolves to a map of jump types and their corresponding list of
  /// [GraphStatsDatePair]s for each jump type. This function takes a [captures] parameter of
  /// type Map<String, List<Capture>> and retrieves the jump score data for each jump type.
  ///
  /// Parameters:
  /// - [captures] : A map of the capture data. The keys are the dates, and the values are lists
  /// of Captures that were taken on that date.
  ///
  /// Returns:
  /// - A map where the keys are jump types and the values are lists of [GraphStatsDatePair]s,
  /// which represent the jump score and the corresponding date for each score.
  static Future<Map<JumpType, List<GraphStatsDatePair>>>
      getJumpScorePerTypeGraphData(Map<String, List<Capture>> captures) async {
    Map<JumpType, List<GraphStatsDatePair>> mappedJumps = {};
    for (JumpType type in JumpType.values) {
      mappedJumps[type] = await _getJumpScorePerType(captures, type);
    }
    return mappedJumps;
  }

  /// Returns a Future that resolves to a list of [GraphStatsDatePair] objects that represent the average fly time for each
  /// day in the given map of [captures].
  ///
  /// Parameters:
  /// - [captures]: a Map of strings to lists of [Capture] objects that represent the user's jump data
  ///
  /// Returns:
  /// - A Future that resolves to a list of [GraphStatsDatePair] objects, where each object contains a date and the
  /// average fly time for that day. If there is no jump data for a given day, no [GraphStatsDatePair] object is included in the list.
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

  /// This function returns a list of dates that are included in a given map of [captures].
  ///
  /// Parameters:
  /// - [captures]: a map of dates with corresponding captures
  ///
  /// Return:
  /// - A list of strings representing dates that are included in the given map of captures.
  static List<String> _getAllDates(Map<String, List<Capture>> captures) {
    List<String> dates = captures.keys.toList();
    dates.removeWhere((element) =>
        DateTime.parse(element).isBefore(GraphDatePreferencesUtils.begin) ||
        DateTime.parse(element).isAfter(GraphDatePreferencesUtils.end));
    return dates;
  }

  /// Calculates the average jump score per type on a specific day and returns the result as a [GraphStatsDatePair].
  ///
  /// Parameters:
  /// - [captures]: A [Map] containing a list of [Capture] objects for each date.
  /// - [day]: A [String] representing the day to calculate the average jump score on.
  /// - [type]: A [JumpType] representing the type of jump to calculate the average score for.
  ///
  /// Return:
  /// - A [GraphStatsDatePair] object containing the average score, standard deviation, minimum score, maximum score,
  /// and the date of the calculated values. If no jumps of the specified type were found on the given day, null is returned.
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

  /// This function calculates the standard deviation of a list of integers.
  ///
  /// Parameters:
  /// - [list]: The list of integers for which to calculate the standard deviation.
  ///
  /// Return:
  /// A double representing the standard deviation of the input list of integers.
  static double _standardDeviation(List<int> list) {
    final double mean = list.average;
    final List<num> squaredDiffs = list.map((x) => pow(x - mean, 2)).toList();
    final double variance = squaredDiffs.sum / squaredDiffs.length;
    return sqrt(variance);
  }

  /// Calculates the average duration of all jumps captured on a specific date.
  /// Returns null if there are no jumps on that date.
  ///
  /// Exceptions:
  /// - throws ArgumentError if the captures map does not contain the specified day or if it is empty.
  ///
  /// Parameters:
  /// - [captures] : a map with dates as keys and lists of Capture objects as values.
  /// - [day] : the specific date to calculate the average jump duration for, in the format 'yyyy-MM-dd'.
  ///
  /// Return:
  /// - a GraphStatsDatePair object containing the average jump duration, standard
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

  /// Extracts all jumps from a list of captures and optionally applies a test to filter the results.
  ///
  /// Parameters:
  /// - [captures]: the list of captures from which to extract jumps.
  /// - [test] (optional): a test to apply to filter the jumps. Only jumps that pass the test will be included in the result.
  ///
  /// Returns: a Future that completes with a list of jumps extracted from the captures. If [test] is provided and
  /// no jump passed it, the function returns an empty list. If [captures] is empty or null, the function returns an empty list.
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

  /// Returns a list of GraphStatsDatePair, which represents the average jump score of the given type for each day
  /// in the captures data.
  ///
  /// Parameters:
  /// - [captures]: a map of captured data for different days, where the key is the day in the format of "yyyy-MM-dd",
  /// and the value is a list of Capture objects.
  /// - [type]: a JumpType enum value that specifies the type of jump score to be retrieved.
  ///
  /// Return:
  /// - A Future that resolves to a list of GraphStatsDatePair objects. Each GraphStatsDatePair object contains the
  /// date and the corresponding average jump score of the given type on that date. If no data is available for a
  /// particular date, it will be excluded from the list.
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
