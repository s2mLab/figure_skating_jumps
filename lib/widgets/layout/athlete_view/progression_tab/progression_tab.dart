import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/utils/graphic_data_helper.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../models/capture.dart';
import '../../../../models/graphic_data_classes/value_date_pair.dart';

class ProgressionTab extends StatelessWidget {
  const ProgressionTab({Key? key, required this.captures}) : super(key: key);
  final Map<String, List<Capture>> captures;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                _getSucceededJumpsGraphic(),
                _getSucceededJumpsGraphic(),
                _getSucceededJumpsGraphic(),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _getSucceededJumpsGraphic() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(
            text: 'Score moyen par saut dans le temps',
            textStyle: const TextStyle(fontFamily: 'Jost')),
        // Enable legend
        legend: Legend(isVisible: true),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: List<ChartSeries<ValueDatePair, String>>.generate(
            JumpType.values.length - 1, (index) {
          return LineSeries<ValueDatePair, String>(
              color: JumpType.values[index].color,
              dataSource: GraphicDataHelper.getJumpScorePerTypeGraphData(
                  captures, JumpType.values[index]),
              xValueMapper: (ValueDatePair data, _) => data.day,
              yValueMapper: (ValueDatePair data, _) => data.value,
              markerSettings:
                  const MarkerSettings(isVisible: true, height: 4, width: 4),
              name: JumpType.values[index].abbreviation);
        }));
  }
}
