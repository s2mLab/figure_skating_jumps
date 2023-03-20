import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../enums/jump_type.dart';
import '../../models/capture.dart';
import '../../utils/time_converter.dart';
import 'color_circle.dart';

class CaptureListTile extends StatelessWidget {
  final Capture _currentCapture;
  const CaptureListTile({super.key, required currentCapture})
      : _currentCapture = currentCapture;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${_currentCapture.date.hour}h${_currentCapture.date.minute}",
                style: const TextStyle(fontSize: 24, color: darkText)),
            Row(children: [
              const Icon(Icons.schedule),
              const SizedBox(width: 5),
              Text(
                TimeConverter.intToTime(_currentCapture.duration),
                style: const TextStyle(fontSize: 16, color: darkText),
              )
            ])
          ],
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(JumpType.values.length, (index) {
              return Row(
                children: [
                  ColorCircle(colorCircle: JumpType.values[index].color),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(_currentCapture
                          .jumpTypeCount[JumpType.values[index]]
                          .toString())),
                ],
              );
            }))
      ],
    );
  }
}
