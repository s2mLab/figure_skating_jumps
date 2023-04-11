import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/lang_fr.dart';
import '../../../enums/ice_button_importance.dart';
import '../../../enums/ice_button_size.dart';
import '../../buttons/ice_button.dart';

class NoCameraRecordingDialog extends StatelessWidget {

  const NoCameraRecordingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
        recordingPrompt,
        textAlign: TextAlign.center,
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(16)),
              child: SizedBox(
                  width: ReactiveLayoutHelper.getWidthFromFactor(50),
                  child: const LinearProgressIndicator(
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
