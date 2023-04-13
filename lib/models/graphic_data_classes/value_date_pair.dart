class GraphStatsDatePair {
  final double? average;
  final double? stdDev;
  final num? min;
  final num? max;
  bool wasRendered = false;
  final DateTime day;
  GraphStatsDatePair(this.average, this.stdDev, this.min,
      this.max, this.day);

  GraphStatsDatePair.empty({required this.day, this.average, this.stdDev, this.min, this.max});
}