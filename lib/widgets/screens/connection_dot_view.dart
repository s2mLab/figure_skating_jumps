import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/services/bluetooth_discovery.dart';
import 'package:figure_skating_jumps/widgets/layout/dot_connected.dart';
import 'package:flutter/material.dart';

import '../../constants/lang_fr.dart';
import '../../enums/ice_button_importance.dart';
import '../../enums/ice_button_size.dart';
import '../buttons/ice_button.dart';
import '../buttons/nav_menu_element.dart';
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
      appBar: const Topbar(isDebug: false),
      drawerEnableOpenDragGesture: false,
      drawerScrimColor: Colors.transparent,
      drawer: Padding(
        padding: const EdgeInsets.only(top: 128.0),
        child: Drawer(
          backgroundColor: primaryColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              NavMenuElement(text: 'Données brutes', iconData: Icons.terminal, onPressed: () {}),
            ],
          ),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: const Text(managingXSensDotTitle,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold))),
        Expanded(
            child: BluetoothDiscovery().getDevices().isEmpty
                ? const NoDotConnected()
                : const DotConnected()), //TODO : adjust when real connections
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
                );
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
