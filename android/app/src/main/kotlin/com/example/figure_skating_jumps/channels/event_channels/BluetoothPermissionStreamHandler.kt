package com.example.figure_skating_jumps.channels.event_channels

import io.flutter.plugin.common.EventChannel

/**
 * A class that implements [XSensDotEventStreamHandler]
 * to handle bluetooth permissions stream events
 */
object BluetoothPermissionStreamHandler : XSensDotEventStreamHandler<Boolean>() {
    /**
     * Send bluetooth events to the flutter project
     *
     * @param event The event to send
     */
    override fun sendEvent(event: Boolean) {
        handler.post {
            sink?.success(event)
        }
    }
}