package com.example.figure_skating_jumps.xsens_dot_managers

import com.xsens.dot.android.sdk.events.XsensDotData

class CustomXSensDotData(data: XsensDotData?) {
    private val acc: DoubleArray? = data?.acc
    private val gyr: DoubleArray? = data?.gyr
    private val euler: DoubleArray? = data?.euler
    private val time: Long? = data?.sampleTimeFine
    private val num: Int? = data?.packetCounter
}