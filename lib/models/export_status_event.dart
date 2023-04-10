import 'dart:math';
import 'dart:ui';

import 'package:figure_skating_jumps/constants/lang_fr.dart';

class ExportStatusEvent {
  late double _exportPct;
  late Duration _timeRemaining;

  ExportStatusEvent({required exportPct, required timeRemaining}) {
    _exportPct = clampDouble(exportPct, 0.0, 1.0);
    _timeRemaining = timeRemaining;
  }

  String get formattedTimeRemaining {
    if(_timeRemaining.isNegative) {
      return calculating;
    }
    return (_timeRemaining.inSeconds > 60)
        ? "${_timeRemaining.inMinutes} ${(_timeRemaining.inMinutes > 1) ? minutes : minutes.replaceFirst("s", "")}"
        : "${_timeRemaining.inSeconds} ${(_timeRemaining.inSeconds > 1) ? seconds : seconds.replaceFirst("s", "", seconds.length - 1)}";
  }

  double get exportPct {
    return _exportPct;
  }
}
