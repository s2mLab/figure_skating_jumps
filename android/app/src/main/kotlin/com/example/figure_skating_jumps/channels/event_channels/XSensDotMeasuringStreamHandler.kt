package com.example.figure_skating_jumps.channels.event_channels

import com.example.figure_skating_jumps.x_sens_dot.CustomXSensDotData

object XSensDotMeasuringStreamHandler : XSensDotEventStreamHandler<CustomXSensDotData>() {
    override fun sendEvent(event: CustomXSensDotData) {
        handler.post {
            sink?.success(event.toString())
        }
    }
}