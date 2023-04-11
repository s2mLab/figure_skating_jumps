import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

class DeviceNotReadyDialog extends StatelessWidget {
  const DeviceNotReadyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        errorCaptureStartingPrompt,
        textAlign: TextAlign.center,
        style: TextStyle(color: errorColor),
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
                padding: EdgeInsets.all(16.0),
                child: InstructionPrompt(noDeviceErrorMessage, errorColor)),
            IceButton(
                text: connectXSensDot,
                onPressed: () {
                  Navigator.pushNamed(context, '/ManageDevices');
                },
                textColor: primaryColor,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.secondaryAction,
                iceButtonSize: IceButtonSize.medium),
            IceButton(
                text: goBack,
                onPressed: () {
                  Navigator.pop(context);
                },
                textColor: paleText,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.mainAction,
                iceButtonSize: IceButtonSize.medium),
          ],
        )
      ],
    );
  }
}
