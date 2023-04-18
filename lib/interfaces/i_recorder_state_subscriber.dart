import 'package:figure_skating_jumps/enums/x_sens/recording/recorder_state.dart';

/// Interface for subscribing to changes in the state of a recorder.
abstract class IRecorderSubscriber {
  /// Override this method to handle the changes in the state of a recorder.
  ///
  /// Parameters:
  /// - [state] : The current state of the recorder.
  void onStateChange(RecorderState state);
}