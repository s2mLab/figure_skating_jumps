package com.example.figure_skating_jumps.channels.event_channels

import com.example.figure_skating_jumps.xsens_dot_managers.CustomXSensDotData

object XSensDotMeasuringStreamHandler : XSensDotEventStreamHandler<CustomXSensDotData>() {
    override fun sendEvent(event: CustomXSensDotData) {
        handler.post {
            sink?.success(event.toString())
        }
    }
}