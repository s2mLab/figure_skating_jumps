import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/recording/recorder_state.dart';
import 'package:figure_skating_jumps/interfaces/i_recorder_state_subscriber.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/lang_fr.dart';
import '../../../services/x_sens/x_sens_dot_recording_service.dart';

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
    return _loadingDialog(captureStartingLabel);
  }

  SimpleDialog _fullMemory() {
    return SimpleDialog(
      title: Text(
        errorCaptureStartingLabel,
        textAlign: TextAlign.center,
        style: TextStyle(color: errorColor, fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(16)), child: const InstructionPrompt(memoryErrorInfo, errorColor)),
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
                text: goBackLabel,
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
    return _loadingDialog(erasingDataLabel);
  }

  SimpleDialog _loadingDialog(String message) {
    return SimpleDialog(
      title: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(16)),
              child: SizedBox(
                  width: ReactiveLayoutHelper.getWidthFromFactor(50),
                  child: const LinearProgressIndicator(
                    color: primaryColor,
                    backgroundColor: discreetText,
                  )),
            ),
            Text(pleaseWaitLabel, style: TextStyle(color: errorColor, fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)))
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
