import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/recording/recorder_state.dart';
import 'package:figure_skating_jumps/interfaces/i_recorder_state_subscriber.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_recording_service.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

class StartRecordingDialog extends StatefulWidget {
  const StartRecordingDialog({super.key});

  @override
  State<StartRecordingDialog> createState() => _StartRecordingState();
}

class _StartRecordingState extends State<StartRecordingDialog>
    implements IRecorderSubscriber {
  int _currentId = 0;
  late List<SimpleDialog> _startingState;
  RecorderState _lastState = RecorderState.idle;
  final XSensDotRecordingService _xSensDotRecordingService =
      XSensDotRecordingService();

  @override
  void initState() {
    _lastState = _xSensDotRecordingService.subscribe(this);
    _startingState = [_startingRecording(), _fullMemory(), _erasingMemory()];
    super.initState();
  }

  @override
  void dispose() {
    _xSensDotRecordingService.unsubscribe(this);
    super.dispose();
  }

  @override
  SimpleDialog build(BuildContext context) {
    return _startingState[_currentId];
  }

  SimpleDialog _startingRecording() {
    return _loadingDialog(captureStartingPrompt);
  }

  SimpleDialog _fullMemory() {
    return SimpleDialog(
      title: const Text(
        errorCaptureStartingPrompt,
        textAlign: TextAlign.center,
        style: TextStyle(color: errorColor),
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
                padding: EdgeInsets.all(16.0),
                child: InstructionPrompt(memoryErrorMessage, errorColor)),
            IceButton(
                text: emptyMemoryButton,
                onPressed: () {
                  _xSensDotRecordingService.eraseMemory();
                },
                textColor: paleText,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.mainAction,
                iceButtonSize: IceButtonSize.medium),
            IceButton(
                text: goBack,
                onPressed: () {
                  Navigator.pop(context);
                },
                textColor: primaryColor,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.secondaryAction,
                iceButtonSize: IceButtonSize.medium),
          ],
        )
      ],
    );
  }

  SimpleDialog _erasingMemory() {
    return _loadingDialog(erasingDataPrompt);
  }

  SimpleDialog _loadingDialog(String message) {
    return SimpleDialog(
      title: Text(
        message,
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

  @override
  void onStateChange(RecorderState state) {
    if (state == RecorderState.idle) {
      if (_lastState == RecorderState.preparing) {
        setState(() {
          _currentId = 1;
        });
      }
      if (_lastState == RecorderState.erasing) {
        Navigator.pop(context);
        return;
      }
    }

    _lastState = state;
    if (_lastState == RecorderState.erasing) {
      setState(() {
        _currentId = 2;
      });
    }
    if (_lastState != RecorderState.recording) return;
    Navigator.pop(context);
  }
}
