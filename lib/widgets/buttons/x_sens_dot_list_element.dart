import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class XSensDotListElement extends StatelessWidget {
  final String text;
  final Widget graphic;
  final VoidCallback? onPressed;
  final Color? textColor;
  final bool hasLine;

  const XSensDotListElement(
      {required this.text, required this.graphic, this.onPressed, this.textColor, required this.hasLine, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 0,
      child: Row(children: [
        if(hasLine) Container(
          height: 64,
          width: 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: primaryColorLight),
        ),
        graphic,
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('XSens Dot Christophe',
              style: TextStyle(fontSize: 18, color: textColor ?? textColor)),
        )
      ]),
    );
  }
}
