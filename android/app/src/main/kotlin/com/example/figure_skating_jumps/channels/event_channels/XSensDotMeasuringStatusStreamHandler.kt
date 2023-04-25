package com.example.figure_skating_jumps.channels.event_channels

import com.example.figure_skating_jumps.x_sens_dot.enums.MeasuringStatus

/**
 * A class that implements [XSensDotEventStreamHandler]
 * to handle measuring status stream events
 */
object XSensDotMeasuringStatusStreamHandler : XSensDotEventStreamHandler<MeasuringStatus>() {
    /**
     * Send measuring status events to the flutter project
     *
     * @param event The event to send
     */
    override fun sendEvent(event: MeasuringStatus) {
        XSensDotMeasuringStatusStreamHandler.handler.post {
            XSensDotMeasuringStatusStreamHandler.sink?.success(event.status)
        }
    }
}