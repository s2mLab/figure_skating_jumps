import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/x_sens/recording/recorder_state.dart';
import 'package:figure_skating_jumps/interfaces/i_recorder_state_subscriber.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_recording_service.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/layout/instruction_prompt.dart';
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
  final XSensDotRecordingService _xSensDotRecordingService =
      XSensDotRecordingService();

  @override
  void initState() {
    RecorderState state = _xSensDotRecordingService.subscribe(this);
    if (state == RecorderState.full) _currentId = 1;
    _startingState = [_startingRecording(), _fullMemory(), _erasingMemory()];
    super.initState();
  }

  @override
  void dispose() {
    _xSensDotRecordingService.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (_currentId == 1) _xSensDotRecordingService.acknowledgeError();
          bool canPop = _xSensDotRecordingService.recorderState !=
                  RecorderState.preparing &&
              _xSensDotRecordingService.recorderState !=
                  RecorderState.erasing &&
              _xSensDotRecordingService.recorderState != RecorderState.full;
          return Future<bool>.value(canPop);
        },
        child: _startingState[_currentId]);
  }

  SimpleDialog _startingRecording() {
    return _loadingDialog(captureStartingLabel);
  }

  /// Display SimpleDialog widget that shows an error message indicating that the memory
  /// is full and provides options to erase the memory or go back.
  ///
  /// Return:
  /// - A SimpleDialog widget.
  SimpleDialog _fullMemory() {
    return SimpleDialog(
      title: Text(
        errorCaptureStartingLabel,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: errorColor,
            fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(
                    ReactiveLayoutHelper.getHeightFromFactor(16)),
                child: const InstructionPrompt(memoryErrorInfo, errorColor)),
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
                  _xSensDotRecordingService.acknowledgeError();
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

  /// Display SimpleDialog widget with a loading message, a linear progress indicator and an information text.
  ///
  /// Parameters:
  /// - [message] : A string to be displayed as the title of the dialog.
  ///
  /// Return:
  /// - A SimpleDialog widget.
  SimpleDialog _loadingDialog(String message) {
    return SimpleDialog(
      title: Text(
        message,
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(16)),
              child: SizedBox(
                  width: ReactiveLayoutHelper.getWidthFromFactor(50),
                  child: const LinearProgressIndicator(
                    color: primaryColor,
                    backgroundColor: discreetText,
                  )),
            ),
            Text(pleaseWaitLabel,
                style: TextStyle(
                    color: errorColor,
                    fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)))
          ],
        )
      ],
    );
  }

  /// Updates the state of the widget based on the given [state].
  ///
  /// Parameters:
  /// - [state]: the [RecorderState] to update the widget's state based on.
  @override
  void onStateChange(RecorderState state) {
    switch (state) {
      case RecorderState.idle:
      case RecorderState.recording:
        Navigator.pop(context);
        break;
      case RecorderState.erasing:
        setState(() {
          _currentId = 2;
        });
        break;
      case RecorderState.full:
        setState(() {
          _currentId = 1;
        });
        break;
      default:
        return;
    }
  }
}
