package com.example.figure_skating_jumps.channels.event_channels

/**
 * A class that implements [XSensDotEventStreamHandler]
 * to handle connection stream events
 */
object XSensDotConnectionStreamHandler : XSensDotEventStreamHandler<Int>() {
    /**
     * Send connection events to the flutter project
     *
     * @param event The event to send
     */
    override fun sendEvent(event: Int) {
        handler.post {
            sink?.success(event)
        }
    }
}