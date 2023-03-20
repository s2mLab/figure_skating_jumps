import '../enums/x_sens_device_state.dart';

abstract class IXSensStateSubscriber {
  void onStateChange(XSensDeviceState state);
}