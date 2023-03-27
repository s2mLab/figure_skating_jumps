import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:flutter/material.dart';

class VideoPlayerDialog extends StatelessWidget {
  const VideoPlayerDialog({super.key});
  // Path to video : /storage/emulated/0/Movies/FigureSkatingJumpVideos/REC7363357224652569833.mp4

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: primaryBackground,
        insetPadding: const EdgeInsets.only(left: 16, right: 16),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
              mainAxisSize: MainAxisSize.min, children: const [Text('video')]),
        ));
  }
}
