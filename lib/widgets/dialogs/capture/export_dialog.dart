import 'package:figure_skating_jumps/models/export_status_event.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_recording_service.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/lang_fr.dart';

class ExportDialog extends StatefulWidget {
  const ExportDialog({super.key});

  @override
  State<StatefulWidget> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  final double _initialPct = 0.0;
  final Duration _initialTimeRemaning = Duration(seconds: -1);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        exportingData,
        textAlign: TextAlign.center,
      ),
      children: [
        StreamBuilder<ExportStatusEvent>(
          stream: XSensDotRecordingService().exportStatusStream,
          initialData: ExportStatusEvent(exportPct: _initialPct, timeRemaining: _initialTimeRemaning),
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                      width: 150,
                      child:
                      LinearProgressIndicator(
                        color: primaryColor,
                        backgroundColor: discreetText,
                        value: snapshot.data?.exportPct,
                      )),
                ),
                Text(remainingTime + snapshot.data!.formattedTimeRemaining)
              ],
            );
          }
        )
      ],
    );
  }
}
