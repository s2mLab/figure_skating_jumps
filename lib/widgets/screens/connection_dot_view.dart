import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/widgets/layout/dot_connected.dart';
import 'package:flutter/material.dart';

import '../buttons/connect_new_dot.dart';
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
        const Center(child: ConnectNewDot())
      ]),
    );
  }
}
