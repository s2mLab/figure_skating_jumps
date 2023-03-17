package com.example.figure_skating_jumps.x_sens_dot.enums

enum class RecordingStatus(val status: String) {
    InitDone("InitDone"),
    EnableRecordingNotificationDone("EnableRecordingNotificationDone"),
    RecordingStarted("RecordingStarted"),
    RecordingStopped("RecordingStopped"),
    GetFileInfoDone("GotFileInfo"),
    ExtractingFile("ExtractingFile"),
    ExtractFileDone("ExtractFileDone")
}