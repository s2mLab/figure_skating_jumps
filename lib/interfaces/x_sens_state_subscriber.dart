import '../enums/x_sens_connection_state.dart';

abstract class XSensStateSubscriber {
  void onStateChange(XSensConnectionState state);
}