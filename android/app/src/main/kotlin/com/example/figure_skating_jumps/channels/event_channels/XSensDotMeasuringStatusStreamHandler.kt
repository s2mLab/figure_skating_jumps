package com.example.figure_skating_jumps.channels.event_channels

import com.example.figure_skating_jumps.x_sens_dot.enums.MeasuringStatus

object XSensDotMeasuringStatusStreamHandler : XSensDotEventStreamHandler<MeasuringStatus>() {
    override fun sendEvent(event: MeasuringStatus) {
        XSensDotMeasuringStatusStreamHandler.handler.post {
            XSensDotMeasuringStatusStreamHandler.sink?.success(event.status)
        }
    }
}