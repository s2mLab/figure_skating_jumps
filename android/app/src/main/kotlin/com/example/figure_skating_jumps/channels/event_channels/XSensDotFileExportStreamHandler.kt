package com.example.figure_skating_jumps.channels.event_channels

import io.flutter.plugin.common.EventChannel

object XSensDotFileExportStreamHandler : IXSensDotEventStreamHandler<String> {
    override var sink: EventChannel.EventSink? = null

    override fun sendEvent(event: String) {
        sink?.success(event)
    }
}