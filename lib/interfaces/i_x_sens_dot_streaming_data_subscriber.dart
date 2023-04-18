import 'package:figure_skating_jumps/models/x_sens_dot_data.dart';

/// Interface for subscribing to the measured data received from an XSensDot sensor.
abstract class IXSensDotMeasuringDataSubscriber {
  /// Override this method to handle the received data.
  ///
  /// Parameters:
  /// - [measuredData] : A list of [XSensDotData] objects representing the measured data received from the sensor.
  void onDataReceived(List<XSensDotData> measuredData);
}