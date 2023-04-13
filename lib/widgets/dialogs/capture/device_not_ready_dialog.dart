import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

class DeviceNotReadyDialog extends StatelessWidget {
  const DeviceNotReadyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        errorCaptureStartingLabel,
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
                child: const InstructionPrompt(noDeviceErrorInfo, errorColor)),
            IceButton(
                text: connectXSensDotButton,
                onPressed: () {
                  Navigator.pushNamed(context, '/ManageDevices');
                },
                textColor: primaryColor,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.secondaryAction,
                iceButtonSize: IceButtonSize.medium),
            Padding(
              padding: EdgeInsets.only(
                  top: ReactiveLayoutHelper.getHeightFromFactor(8.0)),
              child: IceButton(
                  text: goBackLabel,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textColor: paleText,
                  color: primaryColor,
                  iceButtonImportance: IceButtonImportance.mainAction,
                  iceButtonSize: IceButtonSize.medium),
            ),
          ],
        )
      ],
    );
  }
}
