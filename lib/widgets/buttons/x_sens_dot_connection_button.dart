import 'package:figure_skating_jumps/enums/x_sens/x_sens_device_state.dart';
import 'package:figure_skating_jumps/interfaces/i_x_sens_state_subscriber.dart';
import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/views/connection_dot_view.dart';
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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const DeviceManagementView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ReactiveLayoutHelper.isTablet()
            ? ReactiveLayoutHelper.getHeightFromFactor(24)
            : 24,
        width: ReactiveLayoutHelper.isTablet()
            ? ReactiveLayoutHelper.getWidthFromFactor(230)
            : 230,
        decoration: BoxDecoration(
          color: connectionState.backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: MaterialButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          onPressed: () {
            Navigator.of(context).pushReplacement(_createRoute());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(connectionState.message,
                  style: [0, 2, 3].contains(connectionState.state)
                      ? connectedStyle
                      : connectingStyle),
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
