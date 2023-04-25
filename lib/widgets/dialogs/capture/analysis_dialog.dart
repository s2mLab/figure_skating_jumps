import 'package:figure_skating_jumps/enums/x_sens/recording/recorder_state.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_recording_service.dart';
import 'package:flutter/material.dart';

import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';

class AnalysisDialog extends StatelessWidget {
  const AnalysisDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        bool canPop =
            XSensDotRecordingService().recorderState != RecorderState.analyzing;
        return Future<bool>.value(canPop);
      },
      child: SimpleDialog(
        title: const Text(
          analyzingDataLabel,
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
              Text(pleaseWaitLabel)
            ],
          )
        ],
      ),
    );
  }
}
