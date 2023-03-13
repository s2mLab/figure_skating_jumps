package com.example.figure_skating_jumps.channels.event_channels

object XSensDotFileExportStreamHandler : XSensDotEventStreamHandler<String>() {
    override fun sendEvent(event: String) {
        handler.post {
            sink?.success(event)
        }
    }
}