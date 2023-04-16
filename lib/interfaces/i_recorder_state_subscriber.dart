import 'package:figure_skating_jumps/enums/x_sens/recording/recorder_state.dart';

abstract class IRecorderSubscriber {
  void onStateChange(RecorderState state);
}