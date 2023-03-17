package com.example.figure_skating_jumps.channels.event_channels

import com.example.figure_skating_jumps.channels.events.RecordingEvent

object XSensDotRecordingStreamHandler : XSensDotEventStreamHandler<RecordingEvent>() {
    override fun sendEvent(event: RecordingEvent) {
        handler.post {
            sink?.success(event.message)
        }
    }
}