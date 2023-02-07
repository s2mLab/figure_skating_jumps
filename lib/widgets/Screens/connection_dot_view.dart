import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/widgets/buttons/connect_new_dot.dart';
import 'package:figure_skating_jumps/widgets/layout/dot_connected.dart';
import 'package:figure_skating_jumps/widgets/layout/no_dot_connected.dart';
import 'package:flutter/material.dart';

class ConnectionDotView extends StatefulWidget {
  const ConnectionDotView({Key? key}) : super(key: key);

  @override
  State<ConnectionDotView> createState() => _ConnectionDotViewState();
}

class _ConnectionDotViewState extends State<ConnectionDotView> {
  String noConnectionMessage() {
    return "Zut! il semblerait que vous n'ayez \n"
        "pas encore associé un appareil \n"
        "XSens DOT. Tapoter le bouton ci-\n"
        "dessous pour commencer.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: Column(children: [
        Container(
            margin: const EdgeInsets.all(16),
            child: const Text('Connecter un XSens DOT',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold))),
        const Expanded(child: false ? NoDotConnected() : DotConnected()),
        const Center(
          child: ConnectNewDot(),
        )
      ]),
    );
  }
}
