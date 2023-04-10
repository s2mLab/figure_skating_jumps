import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:flutter/material.dart';

enum XSensDeviceState {
  disconnected(0, connectionStateMessageDisconnectedLabel, connectedStyle,
      Colors.black, errorColor),
  connecting(
      1,
      connectionStateMessageConnectingLabel,
      connectingStyle,
      reconnectingXSensDotButtonBackground,
      reconnectingXSensDotButtonIndicator),
  connected(2, connectionStateMessageConnectedLabel, connectedStyle,
      primaryColorLight, connectedXSensDotButtonIndicator),
  initialized(3, connectionStateMessageInitializedLabel, connectedStyle,
      primaryColorLight, connectedXSensDotButtonIndicator),
  reconnecting(
      4,
      connectionStateMessageReconnectingLabel,
      connectingStyle,
      reconnectingXSensDotButtonBackground,
      reconnectingXSensDotButtonIndicator),
  startReconnecting(
      5,
      connectionStateMessageReconnectingLabel,
      connectingStyle,
      reconnectingXSensDotButtonBackground,
      reconnectingXSensDotButtonIndicator);

  const XSensDeviceState(this.state, this.message, this.style,
      this.backgroundColor, this.foregroundColor);

  final int state;
  final String message;
  final TextStyle style;
  final Color backgroundColor;
  final Color foregroundColor;
}
