import 'package:figure_skating_jumps/enums/x_sens_device_state.dart';
import 'package:figure_skating_jumps/interfaces/i_x_sens_state_subscriber.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:flutter/material.dart';

class XSensDotConnectionButton extends StatefulWidget {
  const XSensDotConnectionButton({Key? key}) : super(key: key);
  @override
  State<XSensDotConnectionButton> createState() =>
      _XSensDotConnectionButtonState();
}

class _XSensDotConnectionButtonState extends State<XSensDotConnectionButton>
    implements IXSensStateSubscriber {
  XSensDotConnectionService connectionService = XSensDotConnectionService();
  late XSensDeviceState connectionState;

  @override
  void initState() {
    connectionState = connectionService.subscribe(this);
    super.initState();
  }

  @override
  void dispose() {
    connectionService.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 24,
        width: 230,
        decoration: BoxDecoration(
          color: connectionState.backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: MaterialButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/ManageDevices',
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(connectionState.message, style: connectionState.style),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: connectionState.foregroundColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  @override
  void onStateChange(XSensDeviceState state) {
    if (mounted) {
      setState(() {
        connectionState = state;
      });
    }
  }
}
