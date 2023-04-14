import 'package:flutter/cupertino.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/reactive_layout_helper.dart';

class MetricsTooltip extends StatelessWidget {
  final double tooltipDefaultWidth = 130;
  final double tooltipDefaultHeight = 80;
  final dynamic data;
  const MetricsTooltip({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ReactiveLayoutHelper.getHeightFromFactor(tooltipDefaultHeight),
      width: ReactiveLayoutHelper.getWidthFromFactor(tooltipDefaultWidth),
      decoration: BoxDecoration(
        color: primaryColorDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(
            ReactiveLayoutHelper.getHeightFromFactor(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Moyenne: ${(data.average as double).toStringAsFixed(2)}", style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(10), color: paleText)),
            Text("Min: ${data.min}, Max: ${data.max}", style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(10), color: paleText)),
            Text("Écart type: ${(data.stdDev as double).toStringAsFixed(2)}", style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(10), color: paleText))
          ],

        ),
      ),
    );
  }

}