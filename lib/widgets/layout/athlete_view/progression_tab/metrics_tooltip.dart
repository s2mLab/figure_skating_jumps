import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:flutter/cupertino.dart';

class MetricsTooltip extends StatelessWidget {
  final double tooltipDefaultWidth = 130;
  final double tooltipDefaultHeight = 90;
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
            Text(dateDisplayFormat.format(data.day), style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(10), color: paleText)),
            Text("$averageTooltip: ${(data.average as double).toStringAsFixed(2)}", style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(10), color: paleText)),
            Text("$minTooltip: ${data.min}, $maxTooltip: ${data.max}", style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(10), color: paleText)),
            Text("$stdDevTooltip: ${(data.stdDev as double).toStringAsFixed(2)}", style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(10), color: paleText))
          ],

        ),
      ),
    );
  }

}