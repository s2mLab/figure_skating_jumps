package com.example.figure_skating_jumps.channels.event_channels

import com.example.figure_skating_jumps.channels.events.RecordingEvent

/**
 * A class that implements [XSensDotEventStreamHandler]
 * to handle recording stream events
 */
object XSensDotRecordingStreamHandler : XSensDotEventStreamHandler<RecordingEvent>() {
    /**
     * Send recording events to the flutter project
     *
     * @param event The event to send
     */
    override fun sendEvent(event: RecordingEvent) {
        handler.post {
            sink?.success(event.toString())
        }
    }
}