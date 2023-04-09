import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:flutter/material.dart';
import '../../enums/x_sens_device_state.dart';
import '../../interfaces/i_x_sens_state_subscriber.dart';

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
        height: ReactiveLayoutHelper.isTablet() ? ReactiveLayoutHelper.getHeightFromFactor(24) : 24,
        width: ReactiveLayoutHelper.isTablet() ? ReactiveLayoutHelper.getWidthFromFactor(230) : 230,
        decoration: BoxDecoration(
          color: connectionState.backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: MaterialButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          onPressed: () {
            Navigator.pushReplacementNamed(context,'/ManageDevices',
                );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO: The [0,2,3] list specifies the states that have to have a specific style -> move somewhere global
              Text(connectionState.message,
                  style: [0,2,3].contains(connectionState.state) ? connectedStyle : connectingStyle),
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
    if(mounted) {
      setState(() {
        connectionState = state;
      });
    }
  }
}
