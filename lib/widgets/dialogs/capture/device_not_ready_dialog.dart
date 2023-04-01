import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/lang_fr.dart';
import '../../../enums/ice_button_importance.dart';
import '../../../enums/ice_button_size.dart';
import '../../buttons/ice_button.dart';

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
                padding: EdgeInsets.all(16.0), child: InstructionPrompt(noDeviceErrorMessage, errorColor)),
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
