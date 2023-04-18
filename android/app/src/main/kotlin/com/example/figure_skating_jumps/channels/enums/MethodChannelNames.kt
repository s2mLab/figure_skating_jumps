package com.example.figure_skating_jumps.channels.enums

/**
 * A enum class that contains the method channel names
 *
 * @param channelName The name to identify the method channel
 */
enum class MethodChannelNames(val channelName: String) {
    BluetoothChannel("bluetooth-permission-method-channel"),
    RecordingChannel("recording-method-channel"),
    MeasuringChannel("measuring-method-channel"),
    ConnectionChannel("connection-method-channel"),
    ScanChannel("scan-method-channel")
}