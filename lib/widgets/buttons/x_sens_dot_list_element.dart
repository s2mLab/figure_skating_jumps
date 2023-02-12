import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class XSensDotListElement extends StatelessWidget {
  final String text;
  final Widget graphic;
  final VoidCallback? onPressed;

  const XSensDotListElement(
      {required this.text, required this.graphic, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 0,
      color: primaryBackground,
      child: Row(children: [
        Container(
          height: 64,
          width: 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: primaryColorLight),
        ),
        graphic,
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('XSens Dot Christophe',
              style: TextStyle(fontFamily: 'Jost', fontSize: 18)),
        )
      ]),
    );
  }
}
