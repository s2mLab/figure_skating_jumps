import 'package:figure_skating_jumps/models/xsens_dot_data.dart';

abstract class IXSensDotMeasuringDataSubscriber {
  void onDataReceived(List<XSensDotData> measuredData);
}