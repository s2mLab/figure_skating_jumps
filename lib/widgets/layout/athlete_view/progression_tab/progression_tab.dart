import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/utils/graphic_data_helper.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../constants/jump_scores.dart';
import '../../../../constants/lang_fr.dart';
import '../../../../enums/season.dart';
import '../../../../models/capture.dart';
import '../../../../models/graphic_data_classes/value_date_pair.dart';

class ProgressionTab extends StatefulWidget {
  final Map<String, List<Capture>> _captures;
  const ProgressionTab(
      {required Map<String, List<Capture>> captures, super.key})
      : _captures = captures;

  @override
  State<ProgressionTab> createState() => _ProgressionTabState();
}

class _ProgressionTabState extends State<ProgressionTab> {
  Season? _selectedSeason;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(selectSeasonPrompt)),
              DropdownButton<Season>(
                  selectedItemBuilder: (context) {
                    List<Season?> filters = <Season?>[null] + Season.values;
                    return filters.map<Widget>((Season? item) {
                      // This is the widget that will be shown when you select an item.
                      // Here custom text style, alignment and layout size can be applied
                      // to selected item string.
                      return Container(
                        constraints: const BoxConstraints(minWidth: 80),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item == null ? none : item.displayedString,
                              style: const TextStyle(
                                  color: darkText, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  value: _selectedSeason,
                  menuMaxHeight: 300,
                  items: [
                        const DropdownMenuItem<Season>(
                          value: null,
                          child: Text(none),
                        )
                      ] +
                      List<DropdownMenuItem<Season>>.generate(
                          Season.values.length, (index) {
                        return DropdownMenuItem<Season>(
                          value: Season.values[index],
                          child: Text(Season.values[index].displayedString),
                        );
                      }),
                  onChanged: (val) {
                    setState(() {
                      _selectedSeason = val;
                    });
                  }),
            ],
          ),
          Expanded(
              child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _succeededJumpsGraphic(),
                _percentageJumpsSucceededGraphic(),
                _averageJumpDurationGraphic(),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _succeededJumpsGraphic() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
            maximum: jumpScores.first.toDouble(),
            minimum: jumpScores.last.toDouble()),
        // Chart title
        title: ChartTitle(
            text: succeededJumpsGraphicTitle,
            textStyle: const TextStyle(fontFamily: 'Jost')),
        // Enable legend
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
        ),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: List<ChartSeries<ValueDatePair, String>>.generate(
            JumpType.values.length - 1, (index) {
          return LineSeries<ValueDatePair, String>(
              color: JumpType.values[index].color,
              dataSource: GraphicDataHelper.getJumpScorePerTypeGraphData(
                  _getCapturesBySeason(_selectedSeason),
                  JumpType.values[index]),
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
              xValueMapper: (ValueDatePair data, _) => data.day,
              yValueMapper: (ValueDatePair data, _) => data.value,
              markerSettings:
                  const MarkerSettings(isVisible: true, height: 4, width: 4),
              name: JumpType.values[index].abbreviation);
        }));
  }

  Map<String, List<Capture>> _getCapturesBySeason(Season? s) {
    if (s == null) return widget._captures;
    Map<String, List<Capture>> filteredCaptures = {};
    filteredCaptures.addAll(widget._captures);
    filteredCaptures.removeWhere((key, value) => value[0].season != s);
    return filteredCaptures;
  }

  Widget _percentageJumpsSucceededGraphic() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(maximum: 100, interval: 20),
        // Chart title
        title: ChartTitle(
            text: percentageJumpsSucceededGraphicTitle,
            textStyle: const TextStyle(fontFamily: 'Jost')),
        // Enable legend
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
        ),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          LineSeries<ValueDatePair, String>(
              color: secondaryColorDark,
              dataSource: GraphicDataHelper.getPercentageSucceededGraphData(
                  _getCapturesBySeason(_selectedSeason)),
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
              xValueMapper: (ValueDatePair data, _) => data.day,
              yValueMapper: (ValueDatePair data, _) => data.value,
              markerSettings:
                  const MarkerSettings(isVisible: true, height: 4, width: 4),
              name: percentageJumpsSucceededLegend)
        ]);
  }

  Widget _averageJumpDurationGraphic() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(
            text: averageJumpDurationGraphicTitle,
            textStyle: const TextStyle(fontFamily: 'Jost')),
        // Enable legend
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
        ),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          LineSeries<ValueDatePair, String>(
              color: secondaryColor,
              dataSource: GraphicDataHelper.getAverageFlyTimeGraphData(
                  _getCapturesBySeason(_selectedSeason)),
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
              xValueMapper: (ValueDatePair data, _) => data.day,
              yValueMapper: (ValueDatePair data, _) => data.value,
              markerSettings:
                  const MarkerSettings(isVisible: true, height: 4, width: 4),
              name: averageFlyTimeLegend)
        ]);
  }
}
