import 'package:flutter/material.dart';

class XSensDotConnection {
  XSensConnectionState connectionState = XSensConnectionState.disconnected;
  List<XSensStateSubscriber> _connectionStateSubscribers = [];

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