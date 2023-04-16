import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/x_sens/x_sens_device_state.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/icons/x_sens_state_icon.dart';
import 'package:flutter/cupertino.dart';

class NoKnownDevices extends StatelessWidget {
  const NoKnownDevices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        noConnectionInfo,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: discreetText,
          fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)
        ),
      ),
      Container(
          margin: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(16, true)),
          child: const XSensStateIcon(false, XSensDeviceState.reconnecting))
    ]);
  }
}
