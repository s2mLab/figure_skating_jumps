import 'package:figure_skating_jumps/enums/x_sens/x_sens_device_state.dart';

/// Interface for subscribing to changes in the state of a XSens device.
abstract class IXSensStateSubscriber {
  /// Override this method to handle the changes in the state of a XSens device.
  ///
  /// Parameters:
  /// - [state] : The current state of the XSens device.
  void onStateChange(XSensDeviceState state);
}
