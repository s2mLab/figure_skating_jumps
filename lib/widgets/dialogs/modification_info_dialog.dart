import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:figure_skating_jumps/models/modification.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

class ModificationInfoDialog extends StatelessWidget {
  final List<Modification> _orderedModifications;
  const ModificationInfoDialog(
      {required List<Modification> orderedModifications, super.key})
      : _orderedModifications = orderedModifications;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: ReactiveLayoutHelper.getWidthFromFactor(16),
          vertical: ReactiveLayoutHelper.getHeightFromFactor(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(8)),
            child: Text(
              modificationInfoDialogTitle,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: ReactiveLayoutHelper.getHeightFromFactor(20)),
            ),
          ),
          SizedBox(
            height: ReactiveLayoutHelper.getWidthFromFactor(200),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(8)),
                child: Column(
                  children: [
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _orderedModifications.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: ReactiveLayoutHelper
                                        .getHeightFromFactor(4)),
                                child: Text(
                                  dateSecondsDisplayFormat.format(
                                      _orderedModifications[index].date),
                                  style: TextStyle(
                                      color: primaryColorDark,
                                      fontSize: ReactiveLayoutHelper
                                          .getHeightFromFactor(16),
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              InstructionPrompt(
                                  _orderedModifications[index].action,
                                  primaryColorLight),
                            ],
                          );
                        }),
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
