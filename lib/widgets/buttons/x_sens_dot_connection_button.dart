import 'package:figure_skating_jumps/services/x_sens_dot_connection.dart';
import 'package:flutter/cupertino.dart';

class XSensDotConnectionButton extends StatefulWidget {
  const XSensDotConnectionButton({Key? key}): super(key: key);
  @override
  State<XSensDotConnectionButton> createState() => _XSensDotConnectionButtonState();
}

class _XSensDotConnectionButtonState extends State<XSensDotConnectionButton> implements XSensStateSubscriber {
  XSensDotConnection connection = XSensDotConnection();

  @override
  void initState() {
    connection.subscribeConnectionState(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 230,
      color: const Color(0xFF12A411),
    );
  }

  @override
  XSensConnectionState onStateChange(XSensConnectionState state) {
    // TODO: implement onStateChange
    throw UnimplementedError();
  }
}