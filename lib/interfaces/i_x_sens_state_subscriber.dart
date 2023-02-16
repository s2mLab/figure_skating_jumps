import '../enums/x_sens_connection_state.dart';

abstract class IXSensStateSubscriber {
  void onStateChange(XSensConnectionState state);
}