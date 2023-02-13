import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/services/x_sens_dot_connection.dart';
import 'package:figure_skating_jumps/widgets/screens/connection_dot_view.dart';
import 'package:flutter/material.dart';

import '../../constants/lang_fr.dart';
import '../../enums/x_sens_connection_state.dart';
import '../../interfaces/x_sens_state_subscriber.dart';

class XSensDotConnectionButton extends StatefulWidget {
  const XSensDotConnectionButton({Key? key}) : super(key: key);
  @override
  State<XSensDotConnectionButton> createState() =>
      _XSensDotConnectionButtonState();
}

class _XSensDotConnectionButtonState extends State<XSensDotConnectionButton>
    implements XSensStateSubscriber {
  XSensDotConnection connection = XSensDotConnection();
  late XSensConnectionState connectionState;
  final List<String> _connectionStateMessages = [
    connectionStateMessageConnected,
    connectionStateMessageReconnecting,
    connectionStateMessageDisconnected,
  ];
  final List<TextStyle> _connectionStateStyles = [
    const TextStyle(color: connectedXSensDotButtonForeground),
    const TextStyle(color: darkText),
    const TextStyle(color: connectedXSensDotButtonForeground)
  ];
  final List<Color> _connectionBackgroundColors = [
    primaryColorLight,
    reconnectingXSensDotButtonBackground,
    Colors.black
  ];
  final List<Color> _connectionForegroundColors = [
    connectedXSensDotButtonIndicator,
    reconnectingXSensDotButtonIndicator,
    errorColor
  ];

  @override
  void initState() {
    connectionState = connection.subscribeConnectionState(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 24,
        width: 230,
        decoration: BoxDecoration(
          color: _connectionBackgroundColors[connectionState.index],
          borderRadius: BorderRadius.circular(8),
        ),
        child: MaterialButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ConnectionDotView())); // TODO: Risk of pushing non stop the screen on top on an already loaded one.
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_connectionStateMessages[connectionState.index],
                  style: _connectionStateStyles[connectionState.index]),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _connectionForegroundColors[connectionState.index],
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  @override
  void onStateChange(XSensConnectionState state) {
    setState(() {
      connectionState = state;
    });
  }
}
