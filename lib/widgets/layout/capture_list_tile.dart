import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/utils/time_converter.dart';
import 'package:figure_skating_jumps/widgets/dialogs/modification_info_dialog.dart';
import 'package:figure_skating_jumps/widgets/layout/color_circle.dart';
import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: MaterialButton(
        color: cardBackground,
        padding: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onLongPress: () {
          showDialog(
              context: context,
              builder: (_) {
                return ModificationInfoDialog(
                    orderedModifications:
                        _currentCapture.modifications.reversed.toList());
              });
        },
        onPressed: _isInteractive
            ? () {
                Navigator.pushNamed(context, '/EditAnalysis',
                    arguments: _currentCapture);
              }
            : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: _isInteractive
              ? BoxDecoration(borderRadius: BorderRadius.circular(8))
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
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
                          TimeConverter.dateTimeToHoursAndMinutes(
                              _currentCapture.date),
                          style:
                              const TextStyle(fontSize: 24, color: darkText)),
                      Text(
                          TimeConverter.dateTimeToSeconds(_currentCapture.date),
                          style:
                              const TextStyle(fontSize: 14, color: darkText)),
                    ],
                  ),
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                            _currentCapture.hasVideo
                                ? Icons.videocam
                                : Icons.videocam_off,
                            color: darkText),
                        Row(children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(Icons.schedule, color: darkText),
                          ),
                          Text(
                            TimeConverter.msToFormatSMs(
                                _currentCapture.duration),
                            style:
                                const TextStyle(fontSize: 16, color: darkText),
                          )
                        ]),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        List.generate(JumpType.values.length - 1, (index) {
                      return Row(
                        children: [
                          ColorCircle(
                              colorCircle: JumpType.values[index].color),
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                  _currentCapture
                                      .jumpTypeCount[JumpType.values[index]]
                                      .toString(),
                                  style: const TextStyle(color: darkText))),
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
