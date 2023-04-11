import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:flutter/material.dart';

class NoCameraRecordingDialog extends StatelessWidget {
  const NoCameraRecordingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        recordingPrompt,
        textAlign: TextAlign.center,
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                  width: 50,
                  child: LinearProgressIndicator(
                    color: primaryColor,
                    backgroundColor: discreetText,
                  )),
            ),
            IceButton(
                text: stopCapture,
                onPressed: () {
                  Navigator.pop(context);
                },
                textColor: primaryColor,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.secondaryAction,
                iceButtonSize: IceButtonSize.medium),
          ],
        )
      ],
    );
  }
}
