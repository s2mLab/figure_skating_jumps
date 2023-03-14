import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/utils/time_converter.dart';
import 'package:flutter/material.dart';

import '../../constants/lang_fr.dart';

class CapturesTab extends StatefulWidget {
  const CapturesTab({Key? key, required this.captures}) : super(key: key);

  final List<Capture> captures;

  @override
  _CapturesTabState createState() => _CapturesTabState();
}

class _CapturesTabState extends State<CapturesTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(margin: const EdgeInsets.all(8), child: LegendMove()),
        Container(
            height: MediaQuery.of(context).size.height - 300,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: widget.captures.length,
              itemBuilder: (context, index) {
                final item = widget.captures[index];
                final String time = "${item.date.hour}h${item.date.minute}";
                final int duration = item.duration;
                return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(time,
                                style: const TextStyle(
                                    fontSize: 24, color: darkText)),
                            Row(children: [
                              const Icon(Icons.schedule),
                              const SizedBox(width: 5),
                              Text(
                                TimeConverter.intToTime(duration),
                                style: const TextStyle(
                                    fontSize: 16, color: darkText),
                              )
                            ])
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                  color: axelColor,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ],
                        )
                      ],
                    ));
              },
            )),
      ],
    );
  }
}

class LegendMove extends StatelessWidget {
  LegendMove({Key? key}) : super(key: key);

  final List<String> _abbreviation = [
    axelAbbreviation,
    flipAbbreviation,
    loopAbbreviation,
    lutzAbbreviation,
    salchowAbbreviation,
    toeAbbreviation
  ];

  final List<Color> _moveColors = [
    axelColor,
    flipColor,
    loopColor,
    lutzColor,
    salchowColor,
    toeColor
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 30,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: _abbreviation.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: _moveColors[index],
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(_abbreviation[index])),
                    ],
                  ));
            }));
  }
}
