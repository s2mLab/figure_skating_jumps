import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/lang_fr.dart';
import '../../../enums/ice_button_importance.dart';
import '../../../enums/ice_button_size.dart';
import '../../buttons/ice_button.dart';

class NoCameraRecordingDialog extends StatelessWidget {
  final Function() stopRecording;

  const NoCameraRecordingDialog({super.key, required this.stopRecording});

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
                onPressed: () async {
                  Navigator.pop(context);
                  await stopRecording();
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
