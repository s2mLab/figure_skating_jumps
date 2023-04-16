import 'package:figure_skating_jumps/enums/x_sens/recording/recorder_state.dart';
import 'package:figure_skating_jumps/models/export_status_event.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_recording_service.dart';
import 'package:flutter/material.dart';

import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';

class ExportDialog extends StatefulWidget {
  const ExportDialog({super.key});

  @override
  State<StatefulWidget> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        bool canPop =
            XSensDotRecordingService().recorderState != RecorderState.exporting;
        return Future<bool>.value(canPop);
      },
      child: SimpleDialog(
        title: const Text(
          exportingDataLabel,
          textAlign: TextAlign.center,
        ),
        children: [
          StreamBuilder<ExportStatusEvent>(
              stream: XSensDotRecordingService().exportStatusStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                            width: 150,
                            child: LinearProgressIndicator(
                              color: primaryColor,
                              backgroundColor: discreetText,
                              value: snapshot.data?.exportPct,
                            )),
                      ),
                      Text(remainingTimeLabel +
                          snapshot.data!.formattedTimeRemaining)
                    ],
                  );
                } else {
                  return const Center(child: Text(calculatingLabel));
                }
              })
        ],
      ),
    );
  }
}
