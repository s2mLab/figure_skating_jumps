import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ConnectNewDot extends StatefulWidget {
  const ConnectNewDot({Key? key}) : super(key: key);

  @override
  _ConnectNewDotState createState() => _ConnectNewDotState();
}

class _ConnectNewDotState extends State<ConnectNewDot> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                style: TextStyle(color: Colors.white, fontSize: 18),
              ))),
    );
  }
}
