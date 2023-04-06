import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

import '../../constants/lang_fr.dart';

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
              height: 100,
              width: 300,
              decoration: BoxDecoration(
                color: primaryBackground,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: InstructionPrompt(pleaseActivatePermissions, errorColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

}