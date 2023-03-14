import 'dart:ffi';
import 'dart:typed_data';
import 'dart:convert';

class XSensDotData {
  late Float64List acc;
  late Float64List gyr;
  late Float64List euler;
  late int time;
  late int id;

  XSensDotData(
      {required this.acc,
      required this.gyr,
      required this.euler,
      required this.time,
      required this.id});

  XSensDotData.fromEventChannel(String event) {
    var data = jsonDecode(event);
    acc = Float64List.fromList(data['acc'].cast<double>());
    gyr = Float64List.fromList(data['gyr'].cast<double>());
    euler = Float64List.fromList(data['euler'].cast<double>());
    time = data['time'];
    id = data['id'];
  }

  @override
  String toString() {
    if (acc.length != 3 || gyr.length != 3 || euler.length != 3) {
      return "Invalid data";
    }
    int maxDigit = 3;
    String info = "#$id t:$time ";

    String accX = "a-x:${acc[0].toStringAsFixed(maxDigit)} ";
    String accY = "a-y:${acc[1].toStringAsFixed(maxDigit)} ";
    String accZ = "a-z:${acc[2].toStringAsFixed(maxDigit)} ";

    String gyrX = "g-x:${gyr[2].toStringAsFixed(maxDigit)} ";
    String gyrY = "g-y:${gyr[2].toStringAsFixed(maxDigit)} ";
    String gyrZ = "g-z:${gyr[2].toStringAsFixed(maxDigit)} ";

    String eulX = "e-x:${euler[2].toStringAsFixed(maxDigit)} ";
    String eulY = "e-y:${euler[2].toStringAsFixed(maxDigit)} ";
    String eulZ = "e-z:${euler[2].toStringAsFixed(maxDigit)}\n";
    return info + accX + accY + accZ + gyrX + gyrY + gyrZ + eulX + eulY + eulZ;
  }
}
