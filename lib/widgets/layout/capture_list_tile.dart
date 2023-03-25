import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../enums/jump_type.dart';
import '../../models/capture.dart';
import '../../utils/time_converter.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: MaterialButton(
        color: cardBackground,
        padding: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                  Text(
                      "${_currentCapture.date.hour}h${_currentCapture.date.minute}",
                      style: const TextStyle(fontSize: 24, color: darkText)),
                  Row(children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.schedule, color: darkText),
                    ),
                    Text(
                      TimeConverter.intToTime(_currentCapture.duration),
                      style: const TextStyle(fontSize: 16, color: darkText),
                    )
                  ])
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(JumpType.values.length - 1, (index) {
                      return Row(
                        children: [
                          ColorCircle(colorCircle: JumpType.values[index].color),
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
