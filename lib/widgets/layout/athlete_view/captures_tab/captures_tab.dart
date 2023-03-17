import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/utils/time_converter.dart';
import 'package:figure_skating_jumps/widgets/layout/color_circle.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class CapturesTab extends StatelessWidget {
  CapturesTab({Key? key, required this.captures}) : super(key: key);
  final Map<String, List<Capture>> captures;
  final dateDisplayFormat = DateFormat('dd/MM/yyyy');
  final double heightContainer = 110;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(margin: const EdgeInsets.all(8), child: const LegendMove()),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: captures.length,
                itemBuilder: (context, dateIndex) {
                  String key = captures.keys.elementAt(dateIndex);
                  List<Capture> capturesToDisplay = captures[key]!;
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          key.replaceAll('-', '/'),
                          style: const TextStyle(
                              fontSize: 26,
                              color: primaryColorLight,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: capturesToDisplay.length * heightContainer,
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: capturesToDisplay.length,
                                itemBuilder: (context, index) {
                                  Capture currentCapture =
                                      capturesToDisplay[index];
                                  return Container(
                                      margin:
                                          const EdgeInsets.symmetric(vertical: 8),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          color: cardBackground,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${currentCapture.date.hour}h${currentCapture.date.minute}",
                                                  style: const TextStyle(
                                                      fontSize: 24,
                                                      color: darkText)),
                                              Row(children: [
                                                const Icon(Icons.schedule),
                                                const SizedBox(width: 5),
                                                Text(
                                                  TimeConverter.intToTime(
                                                      currentCapture.duration),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: darkText),
                                                )
                                              ])
                                            ],
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: List.generate(
                                                  JumpType.values.length,
                                                  (index) {
                                                return Row(
                                                  children: [
                                                    ColorCircle(
                                                        colorCircle: JumpType
                                                            .values[index].color),
                                                    Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 5),
                                                        child: Text(currentCapture
                                                            .jumpTypeCount[
                                                                JumpType.values[
                                                                    index]]
                                                            .toString())),
                                                  ],
                                                );
                                              }))
                                        ],
                                      ));
                                }))
                      ]);
                },
              ),
            )),
      ],
    );
  }
}

class LegendMove extends StatelessWidget {
  const LegendMove({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(JumpType.values.length, (index) {
          return Row(
            children: [
              ColorCircle(colorCircle: JumpType.values[index].color),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(JumpType.values[index].abbreviation)),
            ],
          );
        }));
  }
}
