import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:flutter/material.dart';

import '../../../../utils/reactive_layout_helper.dart';
import '../../capture_list_tile.dart';
import '../../legend_move.dart';

class CapturesTab extends StatelessWidget {
  const CapturesTab({Key? key, required this.groupedCaptures})
      : super(key: key);
  final Map<String, List<Capture>> groupedCaptures;
  final double heightContainer = 118;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(8)),
            child: const LegendMove()),
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ReactiveLayoutHelper.getWidthFromFactor(16)),
          child: groupedCaptures.isEmpty
              ? Center(
                  child: Text(noCaptureInfo,
                      style: TextStyle(
                          fontSize:
                              ReactiveLayoutHelper.getHeightFromFactor(16))),
                )
              : ListView.builder(
                  itemCount: groupedCaptures.length,
                  itemBuilder: (context, dateIndex) {
                    String key = groupedCaptures.keys.elementAt(dateIndex);
                    List<Capture> capturesToDisplay = groupedCaptures[key]!;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            key.replaceAll('-', '/'),
                            style: TextStyle(
                                fontSize:
                                    ReactiveLayoutHelper.getHeightFromFactor(
                                        26),
                                color: primaryColorLight,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                              height: capturesToDisplay.length *
                                  ReactiveLayoutHelper.getHeightFromFactor(
                                      heightContainer),
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: capturesToDisplay.length,
                                  itemBuilder: (context, index) {
                                    Capture currentCapture =
                                        capturesToDisplay[index];
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
