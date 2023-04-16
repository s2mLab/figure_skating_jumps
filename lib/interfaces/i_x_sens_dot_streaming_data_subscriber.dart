import 'package:figure_skating_jumps/models/x_sens_dot_data.dart';

abstract class IXSensDotMeasuringDataSubscriber {
  void onDataReceived(List<XSensDotData> measuredData);
}