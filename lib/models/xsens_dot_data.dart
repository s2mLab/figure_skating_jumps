import 'dart:typed_data';

class XSensDotData {
  Float64List acc;
  Float64List gyr;
  double time;
  int num;

  XSensDotData(
      {required this.acc,
      required this.gyr,
      required this.time,
      required this.num});
}
