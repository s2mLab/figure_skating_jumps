import 'dart:typed_data';

class XsensDotData {
  late Float64List acc;
  late Float64List gyr;
  late double time;
  late int num;

  XsensDotData(
      {required this.acc,
      required this.gyr,
      required this.time,
      required this.num});
}
