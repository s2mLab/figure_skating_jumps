import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/x_sens/recording/recorder_state.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_recording_service.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:flutter/material.dart';

class NoCameraRecordingDialog extends StatefulWidget {
  const NoCameraRecordingDialog({super.key});

  @override
  State<NoCameraRecordingDialog> createState() => _NoCameraRecordingDialogState();
}

class _NoCameraRecordingDialogState extends State<NoCameraRecordingDialog> {
  bool _captureStopped = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        bool canPop = _captureStopped ||
            XSensDotRecordingService().recorderState != RecorderState.recording;
        return Future<bool>.value(canPop);
      },
      child: SimpleDialog(
        title: Text(
          style:
              TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
          recordingLabel,
          textAlign: TextAlign.center,
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(
                    ReactiveLayoutHelper.getHeightFromFactor(16)),
                child: SizedBox(
                    width: ReactiveLayoutHelper.getWidthFromFactor(50),
                    child: const LinearProgressIndicator(
                      color: primaryColor,
                      backgroundColor: discreetText,
                    )),
              ),
              IceButton(
                  text: stopCaptureButton,
                  onPressed: () {
                    _captureStopped = true;
                    Navigator.pop(context);
                  },
                  textColor: primaryColor,
                  color: primaryColor,
                  iceButtonImportance: IceButtonImportance.secondaryAction,
                  iceButtonSize: IceButtonSize.medium),
            ],
          )
        ],
      ),
    );
  }
}
