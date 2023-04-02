package com.example.figure_skating_jumps.x_sens_dot.callbacks

import android.content.Context
import android.os.SystemClock
import android.util.Log
import com.example.figure_skating_jumps.channels.event_channels.XSensDotRecordingStreamHandler
import com.example.figure_skating_jumps.channels.events.RecordingEvent
import com.example.figure_skating_jumps.x_sens_dot.CustomXSensDotData
import com.example.figure_skating_jumps.x_sens_dot.enums.RecordingStatus
import com.example.figure_skating_jumps.x_sens_dot.utils.XSensFileInfoSerializer
import com.xsens.dot.android.sdk.events.XsensDotData
import com.xsens.dot.android.sdk.interfaces.XsensDotRecordingCallback
import com.xsens.dot.android.sdk.models.XsensDotDevice
import com.xsens.dot.android.sdk.models.XsensDotRecordingFileInfo
import com.xsens.dot.android.sdk.models.XsensDotRecordingState
import com.xsens.dot.android.sdk.recording.XsensDotRecordingManager
import kotlin.collections.ArrayList

class XSensDotRecorder(context: Context, device: XsensDotDevice) :
    XsensDotRecordingCallback {
    private var recordingManager: XsensDotRecordingManager
    private var isNotificationEnabled: Boolean = false
    private val sleepingTimeMs: Long = 30
    private val maxUsedSpacePct: Double = 0.9

    init {
        recordingManager = XsensDotRecordingManager(context, device, this)
    }

    fun startRecording() {
        SystemClock.sleep(sleepingTimeMs)
        recordingManager.startRecording()
    }

    fun stopRecording() {
        SystemClock.sleep(sleepingTimeMs)
        recordingManager.stopRecording()
    }

    fun enableDataRecordingNotification() {
        SystemClock.sleep(sleepingTimeMs)
        recordingManager.enableDataRecordingNotification()
    }

    fun getFlashInfo() {
        Log.i("XSensDot", "Is notification enable $isNotificationEnabled")
        if (isNotificationEnabled) {
            SystemClock.sleep(sleepingTimeMs)
            recordingManager.requestFlashInfo()
        }
    }

    fun clearManager() {
        recordingManager.clear()
    }

    override fun onXsensDotRecordingNotification(address: String?, isEnabled: Boolean) {
        Log.i("XSensDot", "onXsensDotRecordingNotification")
        Log.i("XSensDot", "Notification Enabled $isEnabled")
        isNotificationEnabled = isEnabled
        XSensDotRecordingStreamHandler.sendEvent(
            RecordingEvent(
                RecordingStatus.EnableRecordingNotificationDone,
                isEnabled.toString()
            )
        )
    }

    override fun onXsensDotEraseDone(address: String?, isSuccess: Boolean) {}

    override fun onXsensDotRequestFlashInfoDone(
        address: String?,
        usedFlashSpace: Int,
        totalFlashSpace: Int
    ) {
        Log.i("XSensDot", "onXsensDotRequestFlashInfoDone")
        Log.i("XSensDot", "$usedFlashSpace $totalFlashSpace")
        val canRecord = usedFlashSpace.toDouble() / totalFlashSpace.toDouble() < maxUsedSpacePct
        XSensDotRecordingStreamHandler.sendEvent(
            RecordingEvent(
                RecordingStatus.GetFlashInfoDone,
                canRecord.toString()
            )
        )
    }

    override fun onXsensDotRecordingAck(
        address: String?,
        recordingId: Int,
        isSuccess: Boolean,
        recordingState: XsensDotRecordingState?
    ) {
        when (recordingId) {
            XsensDotRecordingManager.RECORDING_ID_START_RECORDING -> {
                Log.i("XSensDot", "start CallBack")
                XSensDotRecordingStreamHandler.sendEvent(RecordingEvent(RecordingStatus.RecordingStarted))
            }
            XsensDotRecordingManager.RECORDING_ID_STOP_RECORDING -> {
                Log.i("XSensDot", "stop CallBack")
                XSensDotRecordingStreamHandler.sendEvent(RecordingEvent(RecordingStatus.RecordingStopped))
            }
            XsensDotRecordingManager.RECORDING_ID_GET_STATE ->
                Log.i("XSensDot", "Current state $recordingState")
        }
    }

    override fun onXsensDotGetRecordingTime(
        address: String?,
        startUTCSeconds: Int,
        totalRecordingSeconds: Int,
        remainingRecordingSeconds: Int
    ) {
        Log.i("XSensDot", "onXsensDotGetRecordingTime")
    }

    override fun onXsensDotRequestFileInfoDone(
        address: String?,
        fileInfoList: ArrayList<XsensDotRecordingFileInfo>?,
        isSuccess: Boolean
    ) {}

    override fun onXsensDotDataExported(
        address: String?,
        fileInfo: XsensDotRecordingFileInfo?,
        exportedData: XsensDotData?
    ) {}

    override fun onXsensDotDataExported(address: String?, fileInfo: XsensDotRecordingFileInfo?) {}

    override fun onXsensDotAllDataExported(address: String?) {}

    override fun onXsensDotStopExportingData(address: String?) {}
}