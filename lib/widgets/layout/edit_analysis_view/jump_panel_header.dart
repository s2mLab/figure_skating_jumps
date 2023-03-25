import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/utils/time_converter.dart';
import 'package:figure_skating_jumps/widgets/buttons/x_sens_dot_list_element.dart';
import 'package:flutter/material.dart';

import '../../../constants/lang_fr.dart';
import '../../../models/jump.dart';

class JumpPanelHeader extends StatelessWidget {
  final Jump _jump;

  const JumpPanelHeader({super.key, required jump}) : _jump = jump;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: XSensDotListElement(
        text: _jump.type.abbreviation,
        textColor: _jump.type.color,
        graphic: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              const Icon(Icons.access_time_rounded, color: darkText),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: SizedBox(width: 100, child: Text(TimeConverter.intToTime(_jump.time),style: const TextStyle(color: darkText))),
              ),
              const Text('$jumpType:')
            ],
          ),
        ),
        hasLine: true,
        lineColor: _jump.type.color,
      ),
    );
  }
}