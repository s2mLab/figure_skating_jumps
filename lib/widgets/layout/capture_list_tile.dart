import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/models/firebase/capture.dart';
import 'package:figure_skating_jumps/models/firebase/jump.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/utils/time_converter.dart';
import 'package:figure_skating_jumps/widgets/dialogs/modification_info_dialog.dart';
import 'package:figure_skating_jumps/widgets/layout/color_circle.dart';
import 'package:flutter/material.dart';

class CaptureListTile extends StatefulWidget {
  final Capture _currentCapture;
  final bool _isInteractive;
  final List<Jump>? _jumps;

  const CaptureListTile(
      {super.key,
      required Capture currentCapture,
      bool isInteractive = true,
      List<Jump>? jumps})
      : _currentCapture = currentCapture,
        _isInteractive = isInteractive,
        _jumps = jumps;

  @override
  State<StatefulWidget> createState() => CaptureListTileState();
}

class CaptureListTileState extends State<CaptureListTile> {
  late Capture _currentCapture;
  late bool _isInteractive;
  List<Jump>? _jumps;

  bool get _loadRequired {
    return _jumps == null;
  }

  Future<void> _loadCaptureData() async {
    _jumps = await _currentCapture.getJumpsData();
  }

  void _initializeVariables() {
    _currentCapture = widget._currentCapture;
    _isInteractive = widget._isInteractive;
    _jumps = widget._jumps;
  }

  @override
  Widget build(BuildContext context) {
    _initializeVariables();
    return _loadRequired ? FutureBuilder(
        future: _loadCaptureData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(height: ReactiveLayoutHelper.getHeightFromFactor(115));
          }
          return _captureListTileContent();
        }) : _captureListTileContent();
  }

  Widget _captureListTileContent() {
    Map<JumpType, int> jumpTypeCount = Capture.getJumpTypeCount(_jumps!);
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
      child: MaterialButton(
        color: cardBackground,
        padding: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                ReactiveLayoutHelper.getHeightFromFactor(8))),
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
          padding: EdgeInsets.all(
              ReactiveLayoutHelper.getHeightFromFactor(16)),
          decoration: _isInteractive
              ? BoxDecoration(
              borderRadius: BorderRadius.circular(
                  ReactiveLayoutHelper.getHeightFromFactor(8)))
              : BoxDecoration(
              borderRadius: BorderRadius.circular(
                  ReactiveLayoutHelper.getHeightFromFactor(8)),
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
                          style: TextStyle(
                              fontSize: ReactiveLayoutHelper
                                  .getHeightFromFactor(24),
                              color: darkText)),
                      Text(
                          TimeConverter.dateTimeToSeconds(
                              _currentCapture.date),
                          style: TextStyle(
                              fontSize: ReactiveLayoutHelper
                                  .getHeightFromFactor(14),
                              color: darkText)),
                    ],
                  ),
                  SizedBox(
                    width: ReactiveLayoutHelper.getWidthFromFactor(200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                            _currentCapture.hasVideo
                                ? Icons.videocam
                                : Icons.videocam_off,
                            color: darkText),
                        Row(children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: ReactiveLayoutHelper
                                    .getWidthFromFactor(4)),
                            child: const Icon(Icons.schedule,
                                color: darkText),
                          ),
                          Text(
                            TimeConverter.msToFormatSMs(
                                _currentCapture.duration),
                            style: TextStyle(
                                fontSize: ReactiveLayoutHelper
                                    .getHeightFromFactor(16),
                                color: darkText),
                          )
                        ]),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: ReactiveLayoutHelper.getHeightFromFactor(8)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(JumpType.values.length - 1,
                            (index) {
                          return Row(
                            children: [
                              ColorCircle(
                                  colorCircle: JumpType.values[index].color),
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: ReactiveLayoutHelper
                                          .getWidthFromFactor(5)),
                                  child: Text(
                                      jumpTypeCount[JumpType.values[index]]
                                          .toString(),
                                      style: TextStyle(
                                          color: darkText,
                                          fontSize: ReactiveLayoutHelper
                                              .getHeightFromFactor(16)))),
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
