import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class XSensDotListElement extends StatelessWidget {
  final String text;
  final Widget graphic;
  final VoidCallback? onPressed;
  final Color? lineColor;
  final Color? textColor;
  final bool hasLine;

  const XSensDotListElement(
      {required this.text,
      required this.graphic,
      this.onPressed,
      this.textColor,
      required this.hasLine,
      this.lineColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 0,
      padding: EdgeInsets.zero,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        hasLine
            ? Container(
                height: 64,
                width: 4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: lineColor ?? primaryColorLight),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  height: 64,
                  width: 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent),
                ),
              ),
        graphic,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text,
                style: TextStyle(
                    fontSize: 18,
                    color: textColor ?? darkText,
                    overflow: TextOverflow.ellipsis)),
          ),
        )
      ]),
    );
  }
}
