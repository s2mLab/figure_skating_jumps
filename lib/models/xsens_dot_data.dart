import 'dart:typed_data';

class XSensDotData {
  late Float64List acc;
  late Float64List gyr;
  late Float64List euler;
  late double time;
  late int num;

  XSensDotData(
      {required this.acc,
      required this.gyr,
      required this.euler,
      required this.time,
      required this.num});

  XSensDotData.fromEventChannel(Map<String, dynamic> data){
    acc = data['acc'];
    gyr = data['gyr'];
    euler = data['euler'];
    time = data['time'];
    num = data['num'];
  }
}
