class XSensDotConnection {
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

}