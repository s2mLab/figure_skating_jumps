import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:flutter/material.dart';

enum XSensDeviceState {
  disconnected(
      0,
      connectionStateMessageDisconnected,
      Colors.black,
      errorColor),
  connecting(
      1,
      connectionStateMessageConnecting,
      reconnectingXSensDotButtonBackground,
      reconnectingXSensDotButtonIndicator),
  connected(
      2,
      connectionStateMessageConnected,
      primaryColorLight,
      connectedXSensDotButtonIndicator),
  initialized(
      3,
      connectionStateMessageInitialized,
      primaryColorLight,
      connectedXSensDotButtonIndicator),
  reconnecting(
      4,
      connectionStateMessageReconnecting,
      reconnectingXSensDotButtonBackground,
      reconnectingXSensDotButtonIndicator),
  startReconnecting(
      5,
      connectionStateMessageReconnecting,
      reconnectingXSensDotButtonBackground,
      reconnectingXSensDotButtonIndicator);

  const XSensDeviceState(this.state, this.message,
      this.backgroundColor, this.foregroundColor);

  final int state;
  final String message;
  final Color backgroundColor;
  final Color foregroundColor;
}
