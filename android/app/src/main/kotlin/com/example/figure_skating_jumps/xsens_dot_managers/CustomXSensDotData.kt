package com.example.figure_skating_jumps.xsens_dot_managers

import com.xsens.dot.android.sdk.events.XsensDotData
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.buildJsonArray
import kotlinx.serialization.json.buildJsonObject
import kotlinx.serialization.json.putJsonArray

data class CustomXSensDotData(private val data: XsensDotData?) {
    private val acc: DoubleArray? = data?.acc
    private val gyr: DoubleArray? = data?.gyr
    private val euler: DoubleArray? = data?.euler
    private val time: Long? = data?.sampleTimeFine
    private val id: Int? = data?.packetCounter

    override fun toString(): String {
        val json = buildJsonObject {
            putJsonArray("acc") {
                for (metric in acc!!) add(JsonPrimitive(metric))
            }
            putJsonArray("gyr") {
                for (metric in gyr!!) add(JsonPrimitive(metric))
            }
            putJsonArray("euler") {
                for (metric in euler!!) add(JsonPrimitive(metric))
            }
            put("time", JsonPrimitive(time))
            put("id", JsonPrimitive(id))
        }
        return json.toString();
    }
}