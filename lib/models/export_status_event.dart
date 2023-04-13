import 'dart:ui';

import 'package:figure_skating_jumps/constants/lang_fr.dart';

class ExportStatusEvent {
  late double _exportPct;
  late Duration _timeRemaining;

  ExportStatusEvent(
      {required double exportPct, required Duration timeRemaining}) {
    _exportPct = clampDouble(exportPct, 0.0, 1.0);
    _timeRemaining =
        !timeRemaining.isNegative ? timeRemaining : const Duration(seconds: 0);
  }

  String get formattedTimeRemaining {
    return (_timeRemaining.inSeconds > 60)
        ? "${_timeRemaining.inMinutes} ${(_timeRemaining.inMinutes != 1) ? minuteLabel : minuteLabel.replaceFirst("s", "")}"
        : "${_timeRemaining.inSeconds} ${(_timeRemaining.inSeconds != 1) ? secondsLabel : secondsLabel.replaceFirst("s", "", secondsLabel.length - 1)}";
  }

  double get exportPct {
    return _exportPct;
  }
}
