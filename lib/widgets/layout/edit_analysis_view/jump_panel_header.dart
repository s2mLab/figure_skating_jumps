import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/utils/time_converter.dart';
import 'package:figure_skating_jumps/widgets/buttons/x_sens_dot_list_element.dart';
import 'package:flutter/material.dart';

import '../../../constants/lang_fr.dart';
import '../../../models/jump.dart';
import '../../../utils/reactive_layout_helper.dart';

class JumpPanelHeader extends StatelessWidget {
  final Jump _jump;

  const JumpPanelHeader({super.key, required jump}) : _jump = jump;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
      child: XSensDotListElement(
        text: _jump.type.abbreviation,
        textColor: _jump.type.color,
        graphic: Padding(
          padding: EdgeInsets.only(
              left: ReactiveLayoutHelper.getWidthFromFactor(16)),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: ReactiveLayoutHelper.getWidthFromFactor(5)),
                child: SizedBox(
                    width: ReactiveLayoutHelper.getWidthFromFactor(60),
                    child: Text(TimeConverter.msToFormatSMs(_jump.time),
                        style: TextStyle(
                            color: darkText,
                            fontSize:
                                ReactiveLayoutHelper.getHeightFromFactor(16)))),
              ),
              const Icon(Icons.access_time_rounded, color: darkText),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: ReactiveLayoutHelper.getHeightFromFactor(4),
                    horizontal: ReactiveLayoutHelper.getWidthFromFactor(4)),
                child: SizedBox(
                    width: ReactiveLayoutHelper.getWidthFromFactor(70),
                    child: Text(
                      TimeConverter.msToFormatSMs(_jump.duration),
                      style: TextStyle(
                          color: darkText,
                          fontSize:
                              ReactiveLayoutHelper.getHeightFromFactor(16)),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ReactiveLayoutHelper.getWidthFromFactor(5)),
                child: Text(
                  '$jumpType:',
                  style: TextStyle(
                      fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
                ),
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
