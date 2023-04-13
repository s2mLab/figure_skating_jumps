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
import '../../../../utils/reactive_layout_helper.dart';

class ProgressionTab extends StatefulWidget {
  final Map<String, List<Capture>> _captures;
  const ProgressionTab(
      {required Map<String, List<Capture>> groupedCaptures, super.key})
      : _captures = groupedCaptures;

  @override
  State<ProgressionTab> createState() => _ProgressionTabState();
}

class _ProgressionTabState extends State<ProgressionTab> {
  Season? _selectedSeason;
  final double _spacing = 100.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      right: ReactiveLayoutHelper.getWidthFromFactor(8)),
                  child: Text(selectSeasonLabel,
                      style: TextStyle(
                          fontSize:
                              ReactiveLayoutHelper.getHeightFromFactor(16)))),
              DropdownButton<Season>(
                  selectedItemBuilder: (context) {
                    List<Season?> filters = <Season?>[null] + Season.values;
                    return filters.map<Widget>((Season? item) {
                      // This is the widget that will be shown when you select an item.
                      // Here custom text style, alignment and layout size can be applied
                      // to selected item string.
                      return Container(
                        constraints: BoxConstraints(
                            minWidth:
                                ReactiveLayoutHelper.getWidthFromFactor(80)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item == null ? noneLabel : item.displayedString,
                              style: TextStyle(
                                  color: darkText,
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          16)),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  value: _selectedSeason,
                  menuMaxHeight: ReactiveLayoutHelper.getHeightFromFactor(300),
                  items: [
                        DropdownMenuItem<Season>(
                          value: null,
                          child: Text(noneLabel,
                              style: TextStyle(
                                  fontSize:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          16))),
                        )
                      ] +
                      List<DropdownMenuItem<Season>>.generate(
                          Season.values.length, (index) {
                        return DropdownMenuItem<Season>(
                          value: Season.values[index],
                          child: Text(Season.values[index].displayedString,
                              style: TextStyle(
                                  fontSize:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          16))),
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
            padding: EdgeInsets.symmetric(
                horizontal: ReactiveLayoutHelper.isTablet()
                    ? ReactiveLayoutHelper.getWidthFromFactor(8, true)
                    : ReactiveLayoutHelper.getWidthFromFactor(8),
                vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
            child: Column(
              children: [
                _succeededJumpsGraphic(),
                _averageJumpDurationGraphic(),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _succeededJumpsGraphic() {
    return FutureBuilder(
        future: GraphicDataHelper.getJumpScorePerTypeGraphData(
            _getCapturesBySeason(_selectedSeason)),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Padding(
              padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(_spacing)),
              child: const CircularProgressIndicator(),
            );
          }
          return SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                  maximum: jumpScores.first.toDouble(),
                  minimum: jumpScores.last.toDouble()),
              // Chart title
              title: ChartTitle(
                  text: succeededJumpsGraphicTitle,
                  textStyle: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: ReactiveLayoutHelper.getHeightFromFactor(16))),
              // Enable legend
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                textStyle: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: ReactiveLayoutHelper.getHeightFromFactor(12)),
                padding: ReactiveLayoutHelper.getWidthFromFactor(8),
                iconHeight: ReactiveLayoutHelper.getWidthFromFactor(12),
                iconWidth: ReactiveLayoutHelper.getWidthFromFactor(12),
              ),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: List<ChartSeries<ValueDatePair, String>>.generate(
                  JumpType.values.length - 1, (index) {
                return LineSeries<ValueDatePair, String>(
                    color: JumpType.values[index].color,
                    dataSource: snapshot.data![JumpType.values[index]]!,
                    emptyPointSettings:
                        EmptyPointSettings(mode: EmptyPointMode.drop),
                    xValueMapper: (ValueDatePair data, _) => data.day,
                    yValueMapper: (ValueDatePair data, _) => data.value,
                    markerSettings: MarkerSettings(
                        isVisible: true,
                        height: ReactiveLayoutHelper.getWidthFromFactor(4),
                        width: ReactiveLayoutHelper.getWidthFromFactor(4)),
                    name: JumpType.values[index].abbreviation);
              }));
        });
  }

  Map<String, List<Capture>> _getCapturesBySeason(Season? s) {
    if (s == null) return widget._captures;
    Map<String, List<Capture>> filteredCaptures = {};
    filteredCaptures.addAll(widget._captures);
    filteredCaptures.removeWhere((key, value) => value[0].season != s);
    return filteredCaptures;
  }

  Widget _averageJumpDurationGraphic() {
    return FutureBuilder(
        future: GraphicDataHelper.getAverageFlyTimeGraphData(
            _getCapturesBySeason(_selectedSeason)),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Padding(
              padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(_spacing)),
              child: const CircularProgressIndicator(),
            );
          }
          return SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(
                  text: averageJumpDurationGraphicTitle,
                  textStyle: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: ReactiveLayoutHelper.getHeightFromFactor(16))),
              // Enable legend
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                textStyle: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: ReactiveLayoutHelper.getHeightFromFactor(12)),
                padding: ReactiveLayoutHelper.getWidthFromFactor(8),
                iconHeight: ReactiveLayoutHelper.getWidthFromFactor(12),
                iconWidth: ReactiveLayoutHelper.getWidthFromFactor(12),
              ),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: [
                LineSeries<ValueDatePair, String>(
                    color: secondaryColor,
                    dataSource: snapshot.data!,
                    emptyPointSettings:
                        EmptyPointSettings(mode: EmptyPointMode.drop),
                    xValueMapper: (ValueDatePair data, _) => data.day,
                    yValueMapper: (ValueDatePair data, _) => data.value,
                    markerSettings: MarkerSettings(
                        isVisible: true,
                        height: ReactiveLayoutHelper.getWidthFromFactor(4),
                        width: ReactiveLayoutHelper.getWidthFromFactor(4)),
                    name: averageFlyTimeLegend)
              ]);
        });
  }
}
