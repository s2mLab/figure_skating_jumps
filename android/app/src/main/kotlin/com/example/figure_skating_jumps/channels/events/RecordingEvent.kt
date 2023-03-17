package com.example.figure_skating_jumps.channels.events

import com.example.figure_skating_jumps.x_sens_dot.CustomXSensDotData
import com.xsens.dot.android.sdk.models.XsensDotRecordingFileInfo

data class RecordingEvent(val message: String, val data: CustomXSensDotData?, val fileInfo: XsensDotRecordingFileInfo?)
