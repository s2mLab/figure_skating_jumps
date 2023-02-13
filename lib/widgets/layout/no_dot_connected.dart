import 'package:figure_skating_jumps/enums/x_sens_connection_state.dart';
import 'package:figure_skating_jumps/widgets/icons/x_sens_state_icon.dart';
import 'package:flutter/cupertino.dart';
import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';

class NoDotConnected extends StatelessWidget {
  const NoDotConnected({Key? key}) : super(key: key);

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
          child: const XSensStateIcon(false, XSensConnectionState.reconnecting))
    ]);
  }
}
