import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/utils/time_converter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../constants/lang_fr.dart';

class CapturesTab extends StatefulWidget {
  const CapturesTab({Key? key, required this.captures}) : super(key: key);

  final List<Capture> captures;

  @override
  _CapturesTabState createState() => _CapturesTabState();
}

class _CapturesTabState extends State<CapturesTab> {
  DateTime _currentDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final dateDisplayFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(margin: const EdgeInsets.all(8), child: const LegendMove()),
        Container(
            height: MediaQuery.of(context).size.height - 300,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: widget.captures.length,
              itemBuilder: (context, index) {
                final item = widget.captures[index];
                final String time = "${item.date.hour}h${item.date.minute}";
                final int duration = item.duration;
                DateTime date =
                    DateTime(item.date.year, item.date.month, item.date.day);
                bool showDate = !date.isAtSameMomentAs(_currentDate);
                if (showDate) _currentDate = date;
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      showDate
                          ? Text(
                              dateDisplayFormat.format(date),
                              style: const TextStyle(
                                  fontSize: 26,
                                  color: primaryColorLight,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container(),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: cardBackground,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              )
                            ],
                          ))
                    ]);
              },
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
      children: [
        Expanded(child: Container()),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: axelColor, borderRadius: BorderRadius.circular(10)),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: const Text(axelAbbreviation)),
        Expanded(child: Container()),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: flipColor, borderRadius: BorderRadius.circular(10)),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: const Text(flipAbbreviation)),
        Expanded(child: Container()),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: loopColor, borderRadius: BorderRadius.circular(10)),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: const Text(loopAbbreviation)),
        Expanded(child: Container()),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: lutzColor, borderRadius: BorderRadius.circular(10)),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: const Text(lutzAbbreviation)),
        Expanded(child: Container()),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: salchowColor, borderRadius: BorderRadius.circular(10)),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: const Text(salchowAbbreviation)),
        Expanded(child: Container()),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: toeColor, borderRadius: BorderRadius.circular(10)),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: const Text(toeAbbreviation)),
        Expanded(child: Container()),
      ],
    );
  }
}
