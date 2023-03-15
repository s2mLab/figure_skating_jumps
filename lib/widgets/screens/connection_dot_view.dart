import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/x_sens_connection_state.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection.dart';
import 'package:figure_skating_jumps/widgets/layout/dot_connected.dart';
import 'package:figure_skating_jumps/widgets/layout/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';

import '../../constants/lang_fr.dart';
import '../../enums/ice_button_importance.dart';
import '../../enums/ice_button_size.dart';
import '../buttons/ice_button.dart';
import '../dialogs/connection_new_xsens_dot_dialog.dart';
import '../layout/no_dot_connected.dart';
import '../layout/topbar.dart';

class ConnectionDotView extends StatefulWidget {
  const ConnectionDotView({Key? key}) : super(key: key);

  @override
  State<ConnectionDotView> createState() => _ConnectionDotViewState();
}

class _ConnectionDotViewState extends State<ConnectionDotView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(isUserDebuggingFeature: false),
      drawerEnableOpenDragGesture: false,
      drawerScrimColor: Colors.transparent,
      drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: const PageTitle(text: managingXSensDotTitle),
        ),
        Expanded(
            child: XSensDotConnection().connectionState == XSensConnectionState.connected
                ? const DotConnected()
                : const NoDotConnected()),
        Center(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: IceButton(
              text: connectNewXSensDot,
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return const ConnectionNewXSensDotDialog();
                  },
                ).then((value) => setState(()=>{}));
              },
              textColor: paleText,
              color: primaryColor,
              iceButtonImportance: IceButtonImportance.mainAction,
              iceButtonSize: IceButtonSize.large),
        ))
      ]),
    );
  }
}
