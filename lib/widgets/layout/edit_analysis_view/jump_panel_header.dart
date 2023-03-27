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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: XSensDotListElement(
        text: _jump.type.abbreviation,
        textColor: _jump.type.color,
        graphic: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: SizedBox(width: 60, child: Text(TimeConverter.printSecondsAndMilli(Duration(seconds: _jump.time)),style: const TextStyle(color: darkText))),
              ),
              const Icon(Icons.access_time_rounded, color: darkText),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(width: 70, child: Text(TimeConverter.intToTime(_jump.duration), style: const TextStyle(color: darkText),)),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text('$jumpType:'),
              ),

            ],
          ),
        ),
        hasLine: true,
        lineColor: _jump.type.color,
      ),
    );
  }
}
