import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/models/modification.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

import '../../constants/lang_fr.dart';
import '../../constants/styles.dart';

class ModificationInfoDialog extends StatelessWidget {
  final List<Modification> _orderedModifications;
  const ModificationInfoDialog({required List<Modification> orderedModifications, super.key})
      : _orderedModifications = orderedModifications;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              modificationInfoDialogTitle,
              style: TextStyle(color: primaryColor, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  dateSecondsDisplayFormat.format(
                                      _orderedModifications[index].date),
                                  style: const TextStyle(color: primaryColorDark,
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
