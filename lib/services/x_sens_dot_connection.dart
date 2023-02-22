import '../enums/x_sens_connection_state.dart';
import '../interfaces/i_x_sens_state_subscriber.dart';

class XSensDotConnection {
  static final XSensDotConnection _xSensDotConnection =
      XSensDotConnection._internal(XSensConnectionState.disconnected);
  final List<IXSensStateSubscriber> _connectionStateSubscribers = [];
  XSensConnectionState _connectionState;

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory XSensDotConnection() {
    return _xSensDotConnection;
  }

  XSensDotConnection._internal(this._connectionState);

  XSensConnectionState subscribeConnectionState(
      IXSensStateSubscriber subscriber) {
    _connectionStateSubscribers.add(subscriber);
    return getState();
  }

  XSensConnectionState getState() {
    return _connectionState;
  }

  // Temporarily public for testing purposes
  // TODO: Privatize
  void changeState(XSensConnectionState state) {
    _connectionState = state;
    for (IXSensStateSubscriber s in _connectionStateSubscribers) {
      s.onStateChange(state);
    }
  }
}
