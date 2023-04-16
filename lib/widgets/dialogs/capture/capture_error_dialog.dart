import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_recording_service.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/layout/instruction_prompt.dart';
import 'package:flutter/material.dart';

class CaptureErrorDialog extends StatelessWidget {
  const CaptureErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        errorCaptureLabel,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: errorColor,
            fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(
                    ReactiveLayoutHelper.getHeightFromFactor(16)),
                child: const InstructionPrompt(errorCaptureInfo, errorColor)),
            Padding(
              padding: EdgeInsets.only(
                  top: ReactiveLayoutHelper.getHeightFromFactor(8.0)),
              child: IceButton(
                  text: goBackLabel,
                  onPressed: () {
                    XSensDotRecordingService().acknowledgeError();
                    Navigator.pop(context);
                  },
                  textColor: paleText,
                  color: primaryColor,
                  iceButtonImportance: IceButtonImportance.mainAction,
                  iceButtonSize: IceButtonSize.medium))
          ],
        )
      ],
    );
  }
}
