package com.example.figure_skating_jumps.x_sens_dot.enums

/**
 * A enum class that contains the method channel result error codes
 *
 * @param code The error code to send
 */
enum class ErrorCodes(val code: String) {
    ArgNotSet("arg-not-set"),
    BadArgFormat("bad-arg-format"),
    ExtractFailed("extract-failed")
}