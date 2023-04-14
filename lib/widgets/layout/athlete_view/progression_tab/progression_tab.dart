import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/jump_scores.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/enums/season.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/models/graphic_data_classes/graph_stats_date_pair.dart';
import 'package:figure_skating_jumps/utils/graphic_data_helper.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/layout/athlete_view/progression_tab/metrics_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          right: ReactiveLayoutHelper.getWidthFromFactor(8)),
                      child: Text(selectSeasonLabel,
                          style: TextStyle(
                              fontSize:
                                  ReactiveLayoutHelper.getHeightFromFactor(
                                      16)))),
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
                                    ReactiveLayoutHelper.getWidthFromFactor(
                                        80)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  item == null
                                      ? noneLabel
                                      : item.displayedString,
                                  style: TextStyle(
                                      color: darkText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: ReactiveLayoutHelper
                                          .getHeightFromFactor(16)),
                                ),
                              ],
                            ),
                          );
                        }).toList();
                      },
                      value: _selectedSeason,
                      menuMaxHeight:
                          ReactiveLayoutHelper.getHeightFromFactor(300),
                      items: [
                            DropdownMenuItem<Season>(
                              value: null,
                              child: Text(noneLabel,
                                  style: TextStyle(
                                      fontSize: ReactiveLayoutHelper
                                          .getHeightFromFactor(16))),
                            )
                          ] +
                          List<DropdownMenuItem<Season>>.generate(
                              Season.values.length, (index) {
                            return DropdownMenuItem<Season>(
                              value: Season.values[index],
                              child: Text(Season.values[index].displayedString,
                                  style: TextStyle(
                                      fontSize: ReactiveLayoutHelper
                                          .getHeightFromFactor(16))),
                            );
                          }),
                      onChanged: (val) {
                        setState(() {
                          _selectedSeason = val;
                        });
                      }),
                ],
              ),
              IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (_) {

                      return SimpleDialog(
                        title: Text("Filter par date"),
                        contentPadding: EdgeInsets.all(ReactiveLayoutHelper.getWidthFromFactor(16)),
                        insetPadding: EdgeInsets.symmetric(horizontal: ReactiveLayoutHelper.getWidthFromFactor(16, true)),
                        children: [
                          IceButton(text: "Date de début", onPressed: () {
                            showDatePicker(context: context, initialDate: DateTime(2023), firstDate: DateTime(2023), lastDate: DateTime.now());
                          }, textColor: primaryColor, color: primaryColor, iceButtonImportance: IceButtonImportance.secondaryAction, iceButtonSize: IceButtonSize.medium),
                          IceButton(text: "Date de fin", onPressed: () {

                          }, textColor: primaryColor, color: primaryColor, iceButtonImportance: IceButtonImportance.secondaryAction, iceButtonSize: IceButtonSize.medium),

                        ],
                      );
                    }).then((value) {

                    });
                  },
                  icon: Icon(Icons.calendar_month_outlined,
                      size: ReactiveLayoutHelper.getHeightFromFactor(24)))
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
                _scorePerJumpsGraphic(),
                _averageJumpDurationGraphic(),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _scorePerJumpsGraphic() {
    return FutureBuilder(
        future: GraphicDataHelper.getJumpScorePerTypeGraphData(
            _getCapturesBySeason(_selectedSeason)),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Padding(
              padding: EdgeInsets.all(
                  ReactiveLayoutHelper.getHeightFromFactor(_spacing)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Text(calculatingLabel,
                      style: TextStyle(
                          fontSize:
                              ReactiveLayoutHelper.getHeightFromFactor(14)))
                ],
              ),
            );
          }
          return SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
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
              tooltipBehavior: TooltipBehavior(
                  canShowMarker: true,
                  color: primaryColorDark,
                  enable: true,
                  builder: (dynamic data, dynamic point, dynamic series,
                      int pointIndex, int seriesIndex) {
                    return MetricsTooltip(data: data);
                  }),
              series: List<ChartSeries<GraphStatsDatePair, DateTime>>.generate(
                  JumpType.values.length - 1, (index) {
                return LineSeries<GraphStatsDatePair, DateTime>(
                    color: JumpType.values[index].color,
                    dataSource: snapshot.data![JumpType.values[index]]!,
                    emptyPointSettings:
                        EmptyPointSettings(mode: EmptyPointMode.drop),
                    xValueMapper: (GraphStatsDatePair data, _) => data.day,
                    yValueMapper: (GraphStatsDatePair data, _) => data.average,
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
              padding: EdgeInsets.all(
                  ReactiveLayoutHelper.getHeightFromFactor(_spacing)),
              child: const CircularProgressIndicator(),
            );
          }
          return SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
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
              tooltipBehavior: TooltipBehavior(
                  canShowMarker: true,
                  color: primaryColorDark,
                  enable: true,
                  builder: (dynamic data, dynamic point, dynamic series,
                      int pointIndex, int seriesIndex) {
                    return MetricsTooltip(data: data);
                  }),
              series: [
                LineSeries<GraphStatsDatePair, DateTime>(
                    color: secondaryColor,
                    dataSource: snapshot.data!,
                    emptyPointSettings:
                        EmptyPointSettings(mode: EmptyPointMode.drop),
                    xValueMapper: (GraphStatsDatePair data, _) => data.day,
                    yValueMapper: (GraphStatsDatePair data, _) => data.average,
                    markerSettings: MarkerSettings(
                        isVisible: true,
                        height: ReactiveLayoutHelper.getWidthFromFactor(4),
                        width: ReactiveLayoutHelper.getWidthFromFactor(4)),
                    name: averageFlyTimeLegend)
              ]);
        });
  }
}
