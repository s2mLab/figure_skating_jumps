package com.example.figure_skating_jumps.channels.event_channels

import com.example.figure_skating_jumps.permissions.BluetoothPermissionRequest

object BluetoothPermissionStreamHandler :
    XSensDotEventStreamHandler<BluetoothPermissionRequest>() {
    override fun sendEvent(event: BluetoothPermissionRequest) {
        handler.post{
            sink?.success("${event.requestType} ${event.isAccepted}")
        }
    }
}