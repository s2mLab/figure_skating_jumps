import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/services/x_sens_dot_connection.dart';
import 'package:flutter/material.dart';

class XSensDotConnectionButton extends StatefulWidget {
  const XSensDotConnectionButton({Key? key}) : super(key: key);
  @override
  State<XSensDotConnectionButton> createState() =>
      _XSensDotConnectionButtonState();
}

class _XSensDotConnectionButtonState extends State<XSensDotConnectionButton>
    implements XSensStateSubscriber {
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
        decoration: BoxDecoration(
          color: darkText,
          borderRadius: BorderRadius.circular(8),
        ),
        child: MaterialButton(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('XSens DOT Déconnecté', style: TextStyle(color: primaryColorLight)),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: errorColor,
                  borderRadius: BorderRadius.circular(30),
                ),
              )
            ],
          ),
        ));
  }

  @override
  XSensConnectionState onStateChange(XSensConnectionState state) {
    // TODO: implement onStateChange
    throw UnimplementedError();
  }
}
