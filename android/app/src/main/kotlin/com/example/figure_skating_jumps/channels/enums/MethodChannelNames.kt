package com.example.figure_skating_jumps.channels.enums

enum class MethodChannelNames(val channelName: String) {
    BluetoothChannel("bluetooth-permission-method-channel"),
    RecordingChannel("recording-method-channel"),
    MeasuringChannel("measuring-method-channel"),
    ConnectionChannel("connection-method-channel"),
    ScanChannel("scan-method-channel")
}