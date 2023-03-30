import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../models/capture.dart';

class ProgressionTab extends StatelessWidget {
  ProgressionTab({Key? key, required this.captures}) : super(key: key);
  final Map<String, List<Capture>> captures;
  final List<_DummyTempSkatingData> _data = [
    _DummyTempSkatingData('23/02', 35),
    _DummyTempSkatingData('27/02', 28),
    _DummyTempSkatingData('7/03', 34),
    _DummyTempSkatingData('8/03', 32),
    _DummyTempSkatingData('16/03', 40)
  ];
  final List<_DummyTempSkatingData> _data2 = [
    _DummyTempSkatingData('23/02', 15),
    _DummyTempSkatingData('27/02', 18),
    _DummyTempSkatingData('7/03', 44),
    _DummyTempSkatingData('8/03', 12),
    _DummyTempSkatingData('16/03', 10)
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
              child: Column(
          children: [
              Row(
                children: [
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      title: ChartTitle(text: 'Temporary Title', textStyle: const TextStyle(fontFamily: 'Jost')),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<_DummyTempSkatingData, String>>[
                        //TODO: Automate the series generation when we have data (Sprint6)
                        LineSeries<_DummyTempSkatingData, String>(
                            dataSource: _data,
                            xValueMapper: (_DummyTempSkatingData data, _) => data.year,
                            yValueMapper: (_DummyTempSkatingData data, _) => data.score,
                            name: JumpType.axel.abbreviation,
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: false)),
                        LineSeries<_DummyTempSkatingData, String>(
                            dataSource: _data2,
                            xValueMapper: (_DummyTempSkatingData data, _) => data.year,
                            yValueMapper: (_DummyTempSkatingData data, _) => data.score,
                            name: JumpType.loop.abbreviation,
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: false)),
                      ]),

                ],

              ),
              Row(
                children: const [Text("Test")], //TODO: Change when we decide the exact graphics and have data

              ),
              Row(
                children: const [Text("Test")], //TODO: Change when we decide the exact graphics and have data

              )
          ],
        ),
            )),
      ],
    );
  }
}
class _DummyTempSkatingData {
  _DummyTempSkatingData(this.year, this.score);

  final String year;
  final double score;
}