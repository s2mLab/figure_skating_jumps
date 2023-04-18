package com.example.figure_skating_jumps.channels.event_channels

import com.example.figure_skating_jumps.x_sens_dot.CustomXSensDotData

/**
 * A class that implements [XSensDotEventStreamHandler]
 * to handle measuring data stream events
 */
object XSensDotMeasuringStreamHandler : XSensDotEventStreamHandler<CustomXSensDotData>() {
    /**
     * Send measuring data events to the flutter project
     *
     * @param event The event to send
     */
    override fun sendEvent(event: CustomXSensDotData) {
        handler.post {
            sink?.success(event.toString())
        }
    }
}