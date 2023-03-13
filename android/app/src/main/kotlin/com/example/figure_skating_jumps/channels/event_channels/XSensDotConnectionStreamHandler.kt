package com.example.figure_skating_jumps.channels.event_channels

import io.flutter.plugin.common.EventChannel.EventSink

object XSensDotConnectionStreamHandler : IXSensDotEventStreamHandler<String> {
    override var sink: EventSink? = null

    override fun sendEvent(event: String) {
        sink?.success(event)
    }
}