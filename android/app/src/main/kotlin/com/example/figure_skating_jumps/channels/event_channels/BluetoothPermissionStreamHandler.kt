package com.example.figure_skating_jumps.channels.event_channels

import com.example.figure_skating_jumps.permissions.BluetoothPermissionRequest
import io.flutter.plugin.common.EventChannel

object BluetoothPermissionStreamHandler : IXSensDotEventStreamHandler<BluetoothPermissionRequest> {
    override var sink: EventChannel.EventSink? = null

    override fun sendEvent(event: BluetoothPermissionRequest) {
        sink?.success("${event.requestType} ${event.isAccepted}")
    }
}