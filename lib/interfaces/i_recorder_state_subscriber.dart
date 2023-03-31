import 'package:figure_skating_jumps/enums/recording/recorder_state.dart';

abstract class IRecorderSubscriber {
  void onStateChange(RecorderState state);
}