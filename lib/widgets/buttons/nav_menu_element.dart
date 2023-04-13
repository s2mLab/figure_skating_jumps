import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/x_sens_dot_list_element.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class NavMenuElement extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData iconData;

  const NavMenuElement(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.isTablet() ? ReactiveLayoutHelper.getHeightFromFactor(8.0) : 8.0),
          child: XSensDotListElement(
            hasLine: false,
            textColor: paleText,
            text: text,
            graphic: Icon(iconData, color: primaryBackground),
            onPressed: onPressed,
          ),
        ),
        Container(
          color: primaryColorLight,
          height: ReactiveLayoutHelper.isTablet() ? ReactiveLayoutHelper.getHeightFromFactor(1) : 1,
        ),
      ],
    );
  }
}
