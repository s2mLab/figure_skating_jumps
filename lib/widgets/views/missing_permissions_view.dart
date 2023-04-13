import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

class MissingPermissionsView extends StatelessWidget {
  const MissingPermissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorLight,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: ReactiveLayoutHelper.getHeightFromFactor(100),
              width: ReactiveLayoutHelper.getWidthFromFactor(300),
              decoration: BoxDecoration(
                color: primaryBackground,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding:
                    EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(8)),
                child: const InstructionPrompt(
                    pleaseActivatePermissionsInfo, errorColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
