package com.example.figure_skating_jumps.x_sens_dot.enums

/**
 * A enum class that contains the XSens Dot measuring status
 *
 * @param status The measuring status
 */
enum class MeasuringStatus(val status: String) {
    InitDone("InitDone"),
    SetRate("SetRate");
}