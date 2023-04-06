import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class PageTitle extends StatelessWidget {
  final String text;
  const PageTitle({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: primaryColor,
            fontSize: ReactiveLayoutHelper.getHeightFromFactor(24),
            fontWeight: FontWeight.bold,
            fontFamily:
                'Jost')); // Had to specify it here for some reason even if the theme is properly configured
  }
}
