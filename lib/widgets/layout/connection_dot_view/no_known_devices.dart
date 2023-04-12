import 'package:figure_skating_jumps/enums/x_sens_device_state.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/icons/x_sens_state_icon.dart';
import 'package:flutter/cupertino.dart';
import '../../../constants/colors.dart';
import '../../../constants/lang_fr.dart';

class NoKnownDevices extends StatelessWidget {
  const NoKnownDevices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: ReactiveLayoutHelper.getWidthFromFactor(64, true)),
        child: Text(
          noConnectionInfo,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: discreetText,
            fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)
          ),
        ),
      ),
      Container(
          margin: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(16, true)),
          child: const XSensStateIcon(false, XSensDeviceState.reconnecting))
    ]);
  }
}
