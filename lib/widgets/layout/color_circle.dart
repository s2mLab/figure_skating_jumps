import 'package:flutter/material.dart';

import '../../utils/reactive_layout_helper.dart';

class ColorCircle extends StatelessWidget {
  const ColorCircle({Key? key, required this.colorCircle}) : super(key: key);
  final Color colorCircle;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ReactiveLayoutHelper.getHeightFromFactor(12),
        height: ReactiveLayoutHelper.getHeightFromFactor(12),
        decoration: BoxDecoration(
            color: colorCircle, borderRadius: BorderRadius.circular(ReactiveLayoutHelper.getHeightFromFactor(10))));
  }
}
