import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressionTab extends StatelessWidget {
  ProgressionTab({super.key});
  final List<_SalesData> _data = [
    _SalesData('23/02', 35),
    _SalesData('27/02', 28),
    _SalesData('7/03', 34),
    _SalesData('8/03', 32),
    _SalesData('16/03', 40)
  ];
  final List<_SalesData> _data2 = [
    _SalesData('23/02', 15),
    _SalesData('27/02', 18),
    _SalesData('7/03', 44),
    _SalesData('8/03', 12),
    _SalesData('16/03', 10)
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Column(
          children: [
            Row(
              children: [
                SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    // Chart title
                    title: ChartTitle(text: 'Score moyen par type de saut', textStyle: TextStyle(fontFamily: 'Jost')),
                    // Enable legend
                    legend: Legend(isVisible: true),
                    // Enable tooltip
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<_SalesData, String>>[
                      LineSeries<_SalesData, String>(
                          dataSource: _data,
                          xValueMapper: (_SalesData sales, _) => sales.year,
                          yValueMapper: (_SalesData sales, _) => sales.sales,
                          name: 'Ax',
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: false)),
                      LineSeries<_SalesData, String>(
                          dataSource: _data2,
                          xValueMapper: (_SalesData sales, _) => sales.year,
                          yValueMapper: (_SalesData sales, _) => sales.sales,
                          name: 'Lo',
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: false)),
                    ]),

              ],

            ),
            Row(
              children: [Text("a")],

            ),
            Row(
              children: [Text("a")],

            )
          ],
        )),
      ],
    );
  }
}
class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}