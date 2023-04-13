import 'package:figure_skating_jumps/enums/x_sens_device_state.dart';

abstract class IXSensStateSubscriber {
  void onStateChange(XSensDeviceState state);
}
