import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../enums/jump_type.dart';
import '../../models/capture.dart';
import '../../utils/reactive_layout_helper.dart';
import '../../utils/time_converter.dart';
import '../dialogs/modification_info_dialog.dart';
import 'color_circle.dart';

class CaptureListTile extends StatelessWidget {
  final Capture _currentCapture;
  final bool _isInteractive;
  const CaptureListTile(
      {super.key, required currentCapture, isInteractive = true})
      : _currentCapture = currentCapture,
        _isInteractive = isInteractive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
      child: MaterialButton(
        color: cardBackground,
        padding: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ReactiveLayoutHelper.getHeightFromFactor(8))),
        onLongPress: () {
          showDialog(context: context, builder: (_) {
            return ModificationInfoDialog(orderedModifications: _currentCapture.modifications.reversed.toList());
          });
        },
        onPressed: _isInteractive
            ? () {
                Navigator.pushNamed(context, '/EditAnalysis',
                    arguments: _currentCapture);
              }
            : null,
        child: Container(
          padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(16)),
          decoration: _isInteractive
              ? BoxDecoration(borderRadius: BorderRadius.circular(ReactiveLayoutHelper.getHeightFromFactor(8)))
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(ReactiveLayoutHelper.getHeightFromFactor(8)),
                  color: cardBackground),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          TimeConverter.dateTimeToHoursAndMinutes(_currentCapture.date),
                          style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(24), color: darkText)),Text(
                          TimeConverter.dateTimeToSeconds(_currentCapture.date),
                          style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(14), color: darkText)),
                    ],
                  ),
                  SizedBox(
                    width: ReactiveLayoutHelper.getWidthFromFactor(200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(_currentCapture.hasVideo ? Icons.videocam : Icons.videocam_off, color: darkText),
                        Row(children: [
                          Padding(
                            padding: EdgeInsets.only(left: ReactiveLayoutHelper.getWidthFromFactor(4)),
                            child: const Icon(Icons.schedule, color: darkText),
                          ),
                          Text(
                            TimeConverter.msToFormatSMs(_currentCapture.duration),
                            style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16), color: darkText),
                          )
                        ]),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: ReactiveLayoutHelper.getHeightFromFactor(8)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(JumpType.values.length - 1, (index) {
                      return Row(
                        children: [
                          ColorCircle(colorCircle: JumpType.values[index].color),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: ReactiveLayoutHelper.getWidthFromFactor(5)),
                              child: Text(
                                  _currentCapture
                                      .jumpTypeCount[JumpType.values[index]]
                                      .toString(),
                                  style: TextStyle(color: darkText, fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)))),
                        ],
                      );
                    })),
              )
            ],
          ),
        ),
      ),
    );
  }
}
