package com.example.figure_skating_jumps.x_sens_dot.callbacks

import android.content.Context
import android.os.SystemClock
import android.util.Log
import com.example.figure_skating_jumps.channels.event_channels.XSensDotRecordingStreamHandler
import com.example.figure_skating_jumps.channels.events.RecordingEvent
import com.example.figure_skating_jumps.x_sens_dot.CustomXSensDotData
import com.example.figure_skating_jumps.x_sens_dot.enums.RecorderState
import com.example.figure_skating_jumps.x_sens_dot.enums.RecordingStatus
import com.example.figure_skating_jumps.x_sens_dot.utils.XSensFileInfoSerializer
import com.xsens.dot.android.sdk.events.XsensDotData
import com.xsens.dot.android.sdk.interfaces.XsensDotRecordingCallback
import com.xsens.dot.android.sdk.models.XsensDotDevice
import com.xsens.dot.android.sdk.models.XsensDotRecordingFileInfo
import com.xsens.dot.android.sdk.models.XsensDotRecordingState
import com.xsens.dot.android.sdk.recording.XsensDotRecordingManager
import kotlin.collections.ArrayList
import kotlin.math.exp

class XSensDotRecorder(context: Context, xsensDotDevice: XsensDotDevice) :
    XsensDotRecordingCallback {
    private var recordingManager: XsensDotRecordingManager
    private var isNotificationEnabled: Boolean = false
    private var device: XsensDotDevice

    init {
        device = xsensDotDevice
        recordingManager = XsensDotRecordingManager(context, xsensDotDevice, this)
    }

    fun startRecording() {
        recordingManager.startRecording()
    }

    fun stopRecording() {
        recordingManager.stopRecording()
    }

    fun enableDataRecordingNotification() {
        recordingManager.enableDataRecordingNotification()
    }

    fun extractFile(info: XsensDotRecordingFileInfo) {
        recordingManager.startExporting(arrayListOf(info))
    }

    fun getFileInfo() {
        enableDataRecordingNotification()
        Log.i(
            "XSensDot",
            "isActive ${recordingManager.isActive} recordState ${recordingManager.recordingState}"
        )
        Log.i("XSensDot", "Is notification enable $isNotificationEnabled")
        if (isNotificationEnabled) {
            recordingManager.requestFileInfo()
        }
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

    override fun onXsensDotEraseDone(address: String?, p1: Boolean) {
        Log.i("XSensDot", "onXsensDotEraseDone")
    }

    override fun onXsensDotRequestFlashInfoDone(
        address: String?,
        usedFlashSpace: Int,
        totalFlashSpace: Int
    ) {
        Log.i("XSensDot", "onXsensDotRequestFlashInfoDone")
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
    ) {
        if (!isSuccess) {
            Log.i("XSensDot", "File info request was not successful")
            return
        }
        if (fileInfoList == null || fileInfoList.isEmpty()) {
            Log.i("XSensDot", "File info list is empty")
            return
        }
        for (file in fileInfoList) {
            Log.i("XSensDot", file.fileName)
        }

        XSensDotRecordingStreamHandler.sendEvent(
            RecordingEvent(
                RecordingStatus.GetFileInfoDone,
                XSensFileInfoSerializer.serialize(fileInfoList[0])
            )
        )

    }

    override fun onXsensDotDataExported(
        address: String?,
        fileInfo: XsensDotRecordingFileInfo?,
        exportedData: XsensDotData?
    ) {
        Log.i("XSensDot", "Exported this data ${exportedData?.packetCounter}")
        val data = CustomXSensDotData(exportedData)
        XSensDotRecordingStreamHandler.sendEvent(
            RecordingEvent(
                RecordingStatus.ExtractingFile,
                data.toString()
            )
        )
    }

    override fun onXsensDotDataExported(address: String?, fileInfo: XsensDotRecordingFileInfo?) {
        Log.i("XSensDot", "onXsensDotDataExported")
        XSensDotRecordingStreamHandler.sendEvent(RecordingEvent(RecordingStatus.ExtractingFile))
    }

    override fun onXsensDotAllDataExported(address: String?) {
        Log.i("XSensDot", "I am done exporting!")
        XSensDotRecordingStreamHandler.sendEvent(RecordingEvent(RecordingStatus.ExtractFileDone))
    }

    override fun onXsensDotStopExportingData(address: String?) {
        Log.i("XSensDot", "onXsensDotStopExportingData")
    }
}