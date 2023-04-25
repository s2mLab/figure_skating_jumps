import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:flutter/material.dart';

/// This enum represents the state of the current XSens Dot.
enum XSensDeviceState {
  disconnected(
      0, connectionStateMessageDisconnectedLabel, Colors.black, errorColor),
  connecting(
      1,
      connectionStateMessageConnectingLabel,
      reconnectingXSensDotButtonBackground,
      reconnectingXSensDotButtonIndicator),
  connected(2, connectionStateMessageConnectedLabel, primaryColorLight,
      connectedXSensDotButtonIndicator),
  initialized(3, connectionStateMessageInitializedLabel, primaryColorLight,
      connectedXSensDotButtonIndicator),
  reconnecting(
      4,
      connectionStateMessageReconnectingLabel,
      reconnectingXSensDotButtonBackground,
      reconnectingXSensDotButtonIndicator),
  startReconnecting(
      5,
      connectionStateMessageReconnectingLabel,
      reconnectingXSensDotButtonBackground,
      reconnectingXSensDotButtonIndicator);

  const XSensDeviceState(
      this.state, this.message, this.backgroundColor, this.foregroundColor);

  final int state;
  final String message;
  final Color backgroundColor;
  final Color foregroundColor;
}
