/// This enum represents the status of the recording process.
enum RecordingStatus {
  setRate("SetRate"),
  enableRecordingNotificationDone("EnableRecordingNotificationDone"),
  recordingStarted("RecordingStarted"),
  recordingStopped("RecordingStopped"),
  getFlashInfoDone("GotFlashInfo"),
  getFileInfoDone("GotFileInfo"),
  extractingFile("ExtractingFile"),
  extractFileDone("ExtractFileDone"),
  eraseMemoryDone("EraseMemoryDone");

  const RecordingStatus(this.status);

  final String status;
}
