package com.example.figure_skating_jumps.x_sens_dot.enums

enum class RecordingStatus(val status: String) {
    SetRate("SetRate"),
    EnableRecordingNotificationDone("EnableRecordingNotificationDone"),
    RecordingStarted("RecordingStarted"),
    RecordingStopped("RecordingStopped"),
    GetFlashInfoDone("GotFlashInfo"),
    GetFileInfoDone("GotFileInfo"),
    ExtractingFile("ExtractingFile"),
    ExtractFileDone("ExtractFileDone")
}