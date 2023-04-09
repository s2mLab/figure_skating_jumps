import 'package:flutter/material.dart';

import '../../enums/jump_type.dart';
import '../../utils/reactive_layout_helper.dart';
import 'color_circle.dart';

class LegendMove extends StatelessWidget {
  const LegendMove({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(JumpType.values.length - 1, (index) {
          return Row(
            children: [
              ColorCircle(colorCircle: JumpType.values[index].color),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: ReactiveLayoutHelper.getWidthFromFactor(5)),
                  child: Text(JumpType.values[index].abbreviation, style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)))),
            ],
          );
        }));
  }
}