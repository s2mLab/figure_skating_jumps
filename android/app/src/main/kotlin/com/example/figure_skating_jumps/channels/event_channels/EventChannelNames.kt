package com.example.figure_skating_jumps.channels.event_channels

enum class EventChannelNames(val channelName: String) {
    BluetoothChannel("xsens-dot-bluetooth-permission"),
    ConnectionChannel("xsens-dot-connection"),
    FileExportChannel("xsens-dot-file-export"),
    MeasuringChannel("xsens-dot-measuring"),
    RecordingChannel("xsens-dot-recording"),
    ScanChannel("xsens-dot-scan")
}