package com.example.figure_skating_jumps.channels.event_channels

object BluetoothPermissionStreamHandler :
    XSensDotEventStreamHandler<Boolean>() {
    override fun sendEvent(event: Boolean) {
        handler.post{
            sink?.success(event)
        }
    }
}