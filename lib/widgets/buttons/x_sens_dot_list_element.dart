import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class XSensDotListElement extends StatelessWidget {
  final String text;
  final Widget graphic;
  final VoidCallback? onPressed;
  final Color? lineColor;

  const XSensDotListElement(
      {required this.text, required this.graphic, this.onPressed, this.lineColor, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 0,
      color: primaryBackground,
      padding: EdgeInsets.zero,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          height: 64,
          width: 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: lineColor ?? primaryColorLight),
        ),
        graphic,
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 18,
                  color: darkText,
                  overflow: TextOverflow.ellipsis)),
        )
      ]),
    );
  }
}
