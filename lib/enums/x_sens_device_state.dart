enum XSensDeviceState {
  disconnected(0),
  connecting(1),
  connected(2),
  initialized(3),
  reconnecting(4),
  startReconnecting(5);

  const XSensDeviceState(this.state);

  final int state;
}
