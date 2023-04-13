import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/x_sens_device_state.dart';
import 'package:figure_skating_jumps/interfaces/i_x_sens_state_subscriber.dart';
import 'package:figure_skating_jumps/services/manager/bluetooth_device_manager.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/widgets/layout/connection_dot_view/known_devices.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';

import '../../constants/lang_fr.dart';
import '../../enums/ice_button_importance.dart';
import '../../enums/ice_button_size.dart';
import '../../utils/reactive_layout_helper.dart';
import '../buttons/ice_button.dart';
import '../dialogs/xsens_management/connection_new_xsens_dot_dialog.dart';
import '../layout/connection_dot_view/no_known_devices.dart';
import '../layout/scaffold/tablet_topbar.dart';
import '../layout/scaffold/topbar.dart';

class ConnectionDotView extends StatefulWidget {
  const ConnectionDotView({Key? key}) : super(key: key);

  @override
  State<ConnectionDotView> createState() => _ConnectionDotViewState();
}

class _ConnectionDotViewState extends State<ConnectionDotView> implements IXSensStateSubscriber {
  final XSensDotConnectionService _xSensDotConnectionService = XSensDotConnectionService();

  @override
  void initState() {
    super.initState();
    _xSensDotConnectionService.subscribe(this);
  }

  @override
  void dispose() {
    _xSensDotConnectionService.unsubscribe(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReactiveLayoutHelper.isTablet() ? const TabletTopbar(isUserDebuggingFeature: false) as PreferredSizeWidget : const Topbar(isUserDebuggingFeature: false),
      drawerEnableOpenDragGesture: false,
      drawerScrimColor: Colors.transparent,
      drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(16), horizontal: ReactiveLayoutHelper.getHeightFromFactor(32)),
          child: const PageTitle(text: managingXSensDotTitle),
        ),
        Expanded(
            child: BluetoothDeviceManager().devices.isNotEmpty
                ? KnownDevices(
                    refreshParentCallback: () {
                      if (mounted) setState(() {});
                    },
                  )
                : const NoKnownDevices()),
        Center(
            child: Padding(
          padding: EdgeInsets.only(bottom: ReactiveLayoutHelper.getHeightFromFactor(16)),
          child: _xSensDotConnectionService.currentXSensDevice == null ?
          IceButton(
              text: connectNewXSensDotButton,
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return const ConnectionNewXSensDotDialog();
                  },
                ).then((value) => setState(() => {}));
              },
              textColor: paleText,
              color: primaryColor,
              iceButtonImportance: IceButtonImportance.mainAction,
              iceButtonSize: IceButtonSize.large) :
          IceButton(
              text: disconnectDeviceButton,
              onPressed: () {
                _xSensDotConnectionService.disconnect().then((_) => setState(() => {}));
              },
              textColor: errorColor,
              color: errorColor,
              iceButtonImportance: IceButtonImportance.secondaryAction,
              iceButtonSize: IceButtonSize.large)
            ))
      ]),
    );
  }

  @override
  void onStateChange(XSensDeviceState state) {
    setState(() {});
  }
}
