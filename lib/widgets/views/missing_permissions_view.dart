import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/layout/instruction_prompt.dart';
import 'package:flutter/material.dart';

import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';

import 'package:figure_skating_jumps/constants/lang_fr.dart';

class MissingPermissionsView extends StatelessWidget {
  final String _message;
  final Route? _routeToOnBypass;

  const MissingPermissionsView(
      {super.key, required String message, Route? routeToOnBypass})
      : _message = message,
        _routeToOnBypass = routeToOnBypass;

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
              height: ReactiveLayoutHelper.getHeightFromFactor(136),
              width: ReactiveLayoutHelper.getWidthFromFactor(300),
              decoration: BoxDecoration(
                color: primaryBackground,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: ReactiveLayoutHelper.getHeightFromFactor(8),
                    left: ReactiveLayoutHelper.getWidthFromFactor(8),
                    right: ReactiveLayoutHelper.getWidthFromFactor(8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InstructionPrompt(_message, errorColor),
                    if (_routeToOnBypass != null)
                      IceButton(
                          text: bypassButton,
                          onPressed: () {
                            Navigator.pushReplacement(
                                context, _routeToOnBypass!);
                          },
                          textColor: errorColor,
                          color: errorColorDark,
                          iceButtonImportance:
                              IceButtonImportance.secondaryAction,
                          iceButtonSize: IceButtonSize.small)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
