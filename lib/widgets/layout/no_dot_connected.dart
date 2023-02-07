import 'package:flutter/cupertino.dart';
import '../../constants/colors.dart';

class NoDotConnected extends StatelessWidget {
  const NoDotConnected({Key? key}) : super(key: key);

  static const String noConnectionMessage =
      "Zut! il semblerait que vous n'ayez \n"
      "pas encore associé un appareil \n"
      "XSens DOT. Tapoter le bouton ci-\n"
      "dessous pour commencer.";

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text(
        noConnectionMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: discreetText,
        ),
      ),
      Container(
          margin: const EdgeInsets.all(16),
          child: Image.asset('assets/images/missing_xdot.png'))
    ]);
  }
}
