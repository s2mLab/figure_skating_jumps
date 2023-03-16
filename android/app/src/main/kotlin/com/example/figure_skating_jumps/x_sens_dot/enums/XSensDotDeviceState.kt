package com.example.figure_skating_jumps.x_sens_dot.enums

enum class XSensDotDeviceState(val state: Int) {
    disconnected(0),
    connecting(1),
    connected(2),
    initialized(3),
    reconnecting(4),
    startReconnecting(5),

}