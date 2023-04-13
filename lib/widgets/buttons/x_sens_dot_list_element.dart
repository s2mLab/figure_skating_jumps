import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../utils/reactive_layout_helper.dart';

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
                height: ReactiveLayoutHelper.getHeightFromFactor(64),
                width: ReactiveLayoutHelper.getWidthFromFactor(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: lineColor ?? primaryColorLight),
              )
            : Padding(
                padding: EdgeInsets.only(left: ReactiveLayoutHelper.getWidthFromFactor(8)),
                child: Container(
                  height: ReactiveLayoutHelper.getHeightFromFactor(64),
                  width: ReactiveLayoutHelper.getWidthFromFactor(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent),
                ),
              ),
        graphic,
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: ReactiveLayoutHelper.getWidthFromFactor(8)),
            child: Text(text,
                style: TextStyle(
                    fontSize: ReactiveLayoutHelper.getHeightFromFactor(18),
                    color: textColor ?? darkText,
                    overflow: TextOverflow.ellipsis)),
          ),
        )
      ]),
    );
  }
}
