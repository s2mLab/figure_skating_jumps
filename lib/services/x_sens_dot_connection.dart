class XSensDotConnection {
  static final XSensDotConnection _xSensDotConnection = XSensDotConnection._internal();

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory XSensDotConnection() {
    return _xSensDotConnection;
  }
  XSensDotConnection._internal();

  XSensConnectionState connectionState = XSensConnectionState.disconnected;
  final List<XSensStateSubscriber> _connectionStateSubscribers = [];

  bool subscribeConnectionState(XSensStateSubscriber subscriber) {
    _connectionStateSubscribers.add(subscriber);
    return true;
  }



}

enum XSensConnectionState {
  disconnected,
  reconnecting,
  connected,
  unknown
}

abstract class XSensStateSubscriber {

  XSensConnectionState onStateChange(XSensConnectionState state);

}