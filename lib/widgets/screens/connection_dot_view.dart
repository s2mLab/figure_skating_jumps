import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:flutter/material.dart';

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
      body: Column(children: [
        Container(
            margin: const EdgeInsets.all(16),
            child: const Text('Connecter un XSens DOT',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold))),
        Expanded(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            noConnectionMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: discreetText,
            ),
          ),
          Container(
              margin: const EdgeInsets.all(16),
              child: Image.asset('assets/images/missing_xdot.png'))
        ])),
        Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton(
                onPressed: () {},
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      'Connecter un appareil XSens DOT',
                      style: TextStyle(color: paleText, fontSize: 18),
                    ))),
          ),
        )
      ]),
    );
  }
}
