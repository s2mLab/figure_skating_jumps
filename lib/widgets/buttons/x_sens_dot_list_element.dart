import 'package:flutter/cupertino.dart';

import '../../constants/colors.dart';

class XSensDotListElement extends StatelessWidget {
  final String text;
  final Widget graphic;

  const XSensDotListElement(
      {required this.text, required this.graphic, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
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
    ]);
  }
}
