package com.example.figure_skating_jumps.channels.event_channels

object XSensDotConnectionStreamHandler : XSensDotEventStreamHandler<Int>() {
    override fun sendEvent(event: Int) {
        handler.post {
            sink?.success(event)
        }
    }
}