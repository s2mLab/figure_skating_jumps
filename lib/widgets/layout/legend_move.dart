import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/widgets/layout/color_circle.dart';
import 'package:flutter/material.dart';

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
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(JumpType.values[index].abbreviation)),
            ],
          );
        }));
  }
}
