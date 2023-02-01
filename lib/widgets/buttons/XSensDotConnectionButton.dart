import 'package:flutter/cupertino.dart';

class XSensDotConnectionButton extends StatefulWidget {
  const XSensDotConnectionButton({Key? key}): super(key: key);
  @override
  State<XSensDotConnectionButton> createState() => _XSensDotConnectionButtonState();
}

class _XSensDotConnectionButtonState extends State<XSensDotConnectionButton>{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      color: Color(0xFF12A411),
    );
  }
}