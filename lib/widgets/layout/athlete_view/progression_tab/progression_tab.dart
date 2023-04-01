import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/utils/graphic_data_helper.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../constants/lang_fr.dart';
import '../../../../models/capture.dart';
import '../../../../models/graphic_data_classes/value_date_pair.dart';

class ProgressionTab extends StatelessWidget {
  const ProgressionTab({Key? key, required this.captures}) : super(key: key);
  final Map<String, List<Capture>> captures;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  _succeededJumpsGraphic(),
                  _percentageJumpsSucceededGraphic(),
                  _averageJumpDurationGraphic(),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _succeededJumpsGraphic() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(
            text: succeededJumpsGraphicTitle,
            textStyle: const TextStyle(fontFamily: 'Jost')),
        // Enable legend
        legend: Legend(isVisible: true,position: LegendPosition.bottom,),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: List<ChartSeries<ValueDatePair, String>>.generate(
            JumpType.values.length - 1, (index) {
          return LineSeries<ValueDatePair, String>(
              color: JumpType.values[index].color,
              dataSource: GraphicDataHelper.getJumpScorePerTypeGraphData(
                  captures, JumpType.values[index]),
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
              xValueMapper: (ValueDatePair data, _) => data.day,
              yValueMapper: (ValueDatePair data, _) => data.value,
              markerSettings:
                  const MarkerSettings(isVisible: true, height: 4, width: 4),
              name: JumpType.values[index].abbreviation);
        }));
  }

  Widget _percentageJumpsSucceededGraphic() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(
            text: percentageJumpsSucceededGraphicTitle,
            textStyle: const TextStyle(fontFamily: 'Jost')),
        // Enable legend
        legend: Legend(isVisible: true,position: LegendPosition.bottom,),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [LineSeries<ValueDatePair, String>(
            color: secondaryColorDark,
            dataSource: GraphicDataHelper.getPercentageSucceededGraphData(captures),
            emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
            xValueMapper: (ValueDatePair data, _) => data.day,
            yValueMapper: (ValueDatePair data, _) => data.value,
            markerSettings:
            const MarkerSettings(isVisible: true, height: 4, width: 4),
            name: percentageJumpsSucceededLegend)]);

  }

  Widget _averageJumpDurationGraphic() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(
            text: averageJumpDurationGraphicTitle,
            textStyle: const TextStyle(fontFamily: 'Jost')),
        // Enable legend
        legend: Legend(isVisible: true,position: LegendPosition.bottom,),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [LineSeries<ValueDatePair, String>(
            color: secondaryColorDark,
            dataSource: GraphicDataHelper.getPercentageSucceededGraphData(captures),
            emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
            xValueMapper: (ValueDatePair data, _) => data.day,
            yValueMapper: (ValueDatePair data, _) => data.value,
            markerSettings:
            const MarkerSettings(isVisible: true, height: 4, width: 4),
            name: percentageJumpsSucceededLegend)]);

  }
}
