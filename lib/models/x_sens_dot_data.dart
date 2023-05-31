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

  /// Creates a new [XSensDotData] instance from a JSON string received from an
  /// event channel.
  ///
  /// Throws a [FormatException] if the provided JSON string is invalid or does
  /// not have the expected format.
  ///
  /// Parameters:
  /// - [event] : The JSON string received from the event channel.
  ///
  /// Returns a new [XSensDotData] instance with data parsed from the provided
  /// JSON string.
  XSensDotData.fromEventChannel(String event) {
    var data = jsonDecode(event);

    // Make sure there is no "0", but only "0.0"
    for (int i = 0; i < 3; i++) {
      if (data['acc'][i] == 0) data['acc'][i] = 0.0;
      if (data['gyr'][i] == 0) data['gyr'][i] = 0.0;
      if (data['euler'][i] == 0) data['euler'][i] = 0.0;
    }

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
    String gyrZ = "g-z:${gyr[2].toStringAsFixed(maxDigit)}\n";
    return info + accX + accY + accZ + gyrX + gyrY + gyrZ;
  }
}
