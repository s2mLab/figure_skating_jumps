package com.example.figure_skating_jumps.channels.events

import com.example.figure_skating_jumps.x_sens_dot.enums.RecordingStatus
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.buildJsonObject

class RecordingEvent(private val status: RecordingStatus, private val data: String = "") {
    override fun toString(): String {
        val json = buildJsonObject {
            put("status", JsonPrimitive(status.status))
            if(data.isNotEmpty()) put("data", JsonPrimitive(data))
        }
        return json.toString()
    }
}
