/// This enum represents state of the recording process.
enum RecorderState {
  idle,
  preparing,
  recording,
  exporting,
  erasing,
  analyzing,
  error,
  full
}
