import 'dart:io';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerDialog extends StatefulWidget {
  const VideoPlayerDialog({Key? key, required String videoPath})
      : _videoPath = videoPath,
        super(key: key);

  final String _videoPath;

  @override
  State<VideoPlayerDialog> createState() {
    return _VideoPlayerDialogState();
  }
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  final int skipTimeDuration = 3;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    File videoFile = File(widget._videoPath);
    _controller = VideoPlayerController.file(videoFile);

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _playPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        return;
      }
      _controller.play();
    });
  }

  void _jumpTime(Duration time) {
    setState(() {
      _controller.position.then((value) {
        _controller.seekTo(value! + time);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: primaryBackground,
      insetPadding: EdgeInsets.symmetric(horizontal: ReactiveLayoutHelper.getHeightFromFactor(16)),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Padding(
        padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(16)),
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                Stack(children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                          child: GestureDetector(
                        onTap: _playPause,
                        onDoubleTap: () =>
                            _jumpTime(const Duration(seconds: -3)),
                        child:
                            Container(height: ReactiveLayoutHelper.getHeightFromFactor(620), color: Colors.transparent),
                      )),
                      Flexible(
                          child: GestureDetector(
                        onTap: _playPause,
                        onDoubleTap: () =>
                            _jumpTime(const Duration(seconds: 3)),
                        child:
                            Container(height: ReactiveLayoutHelper.getHeightFromFactor(620), color: Colors.transparent),
                      ))
                    ],
                  ),
                ]),
                SmoothVideoProgress(
                    controller: _controller,
                    builder: (context, position, duration, _) {
                      final double max = duration.inMilliseconds.toDouble();
                      return Theme(
                          data: ThemeData.from(
                            colorScheme:
                                ColorScheme.fromSeed(seedColor: primaryColor),
                            useMaterial3: true,
                          ),
                          child: Row(children: [
                            Expanded(
                                child: Slider(
                              min: 0,
                              max: max,
                              value: position.inMilliseconds
                                  .clamp(0, max)
                                  .toDouble(),
                              onChanged: (value) => _controller.seekTo(
                                  Duration(milliseconds: value.toInt())),
                            )),
                            Text(position.toString().substring(2, 11), style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),)
                          ]));
                    }),
              ]);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
