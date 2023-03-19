enum RecordingStatus {
  initDone("InitDone"),
  enableRecordingNotificationDone("EnableRecordingNotificationDone"),
  recordingStarted("RecordingStarted"),
  recordingStopped("RecordingStopped"),
  getFlashInfoDone("GotFlashInfo"),
  getFileInfoDone("GotFileInfo"),
  extractingFile("ExtractingFile"),
  extractFileDone("ExtractFileDone");

  const RecordingStatus(this.status);

  final String status;
}
