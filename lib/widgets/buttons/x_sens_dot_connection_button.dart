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
      height: 24,
      width: 230,
      color: const Color(0xFF12A411),
    );
  }


}