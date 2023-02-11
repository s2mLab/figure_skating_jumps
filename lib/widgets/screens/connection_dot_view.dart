import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/widgets/layout/dot_connected.dart';
import 'package:flutter/material.dart';

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
  String noConnectionMessage = "Zut! il semblerait que vous n'ayez \n"
      "pas encore associé un appareil \n"
      "XSens DOT. Tapoter le bouton ci-\n"
      "dessous pour commencer.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: const Text('Connecter un XSens DOT',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold))),
        const Expanded(child: false ? NoDotConnected() : DotConnected()),
        Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: IceButton(
                  text: 'Connecter un appareil XSens DOT',
                  onPressed: () {
                    showDialog(
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
