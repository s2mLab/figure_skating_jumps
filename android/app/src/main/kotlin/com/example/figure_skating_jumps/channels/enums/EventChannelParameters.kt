package com.example.figure_skating_jumps.channels.enums

import com.example.figure_skating_jumps.channels.event_channels.*
import io.flutter.plugin.common.EventChannel.StreamHandler

enum class EventChannelParameters(val channelName: String, val streamHandler: StreamHandler) {
    BluetoothChannel("xsens-dot-bluetooth-permission", BluetoothPermissionStreamHandler),
    ConnectionChannel("xsens-dot-connection", XSensDotConnectionStreamHandler),
    MeasuringChannel("xsens-dot-measuring", XSensDotMeasuringStreamHandler),
    RecordingChannel("xsens-dot-recording", XSensDotRecordingStreamHandler),
    ScanChannel("xsens-dot-scan", XSensDotScanStreamHandler)
}