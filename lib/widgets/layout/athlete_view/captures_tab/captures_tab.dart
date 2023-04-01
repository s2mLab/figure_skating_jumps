import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:flutter/material.dart';

import '../../capture_list_tile.dart';
import '../../legend_move.dart';

class CapturesTab extends StatelessWidget {
  const CapturesTab({Key? key, required this.captures}) : super(key: key);
  final Map<String, List<Capture>> captures;
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
                              Capture currentCapture = capturesToDisplay[index];
                              return CaptureListTile(
                                  currentCapture: currentCapture);
                            }))
                  ]);
            },
          ),
        )),
      ],
    );
  }
}
