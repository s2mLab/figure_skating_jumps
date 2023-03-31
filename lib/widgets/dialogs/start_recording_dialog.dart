import 'package:figure_skating_jumps/enums/recording/recorder_state.dart';
import 'package:figure_skating_jumps/interfaces/i_recorder_state_subscriber.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../../services/x_sens/x_sens_dot_recording_service.dart';

class StartRecordingDialog extends StatefulWidget {
  const StartRecordingDialog({super.key});

  @override
  State<StartRecordingDialog> createState() => _StartRecordingState();
}

class _StartRecordingState extends State<StartRecordingDialog> implements IRecorderSubscriber {
  bool _isMemoryFull = false;
  RecorderState _lastState = RecorderState.idle;
  final XSensDotRecordingService _xSensDotRecordingService =
  XSensDotRecordingService();

  @override
  void initState() {
    _lastState = _xSensDotRecordingService.subscribe(this);
    super.initState();
  }

  @override
  void dispose() {
    _xSensDotRecordingService.unsubscribe(this);
    super.dispose();
  }

  @override
  SimpleDialog build(BuildContext context) {
    return (!_isMemoryFull) ? _startingRecording() : _fullMemory();
  }

  SimpleDialog _startingRecording() {
    return SimpleDialog(
      title: const Text(
        captureStartingPrompt,
        textAlign: TextAlign.center,
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                  width: 50,
                  child: LinearProgressIndicator(
                    color: primaryColor,
                    backgroundColor: discreetText,
                  )),
            ),
            Text(pleaseWait)
          ],
        )
      ],
    );
  }

  SimpleDialog _fullMemory() {
    return SimpleDialog(
      title: const Text(
        errorCaptureStartingPrompt,
        textAlign: TextAlign.center,
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
                padding: EdgeInsets.all(16.0), child: Text(memoryErrorMessage)),
          ],
        )
      ],
    );
  }

  @override
  void onStateChange(RecorderState state) {
    if(_lastState == RecorderState.preparing && state == RecorderState.idle) {
      setState(() {
        _isMemoryFull = true;
      });
    }
    _lastState = state;
    if(_lastState != RecorderState.recording) return;
    Navigator.pop(context);
  }
}
