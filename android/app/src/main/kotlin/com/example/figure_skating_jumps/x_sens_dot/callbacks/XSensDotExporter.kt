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

class XSensDotExporter(context: Context, device: XsensDotDevice) :
    XsensDotRecordingCallback {
    private var exportingManager: XsensDotRecordingManager
    private var isNotificationEnabled: Boolean = false
    private val sleepingTimeMs: Long = 30
    private val selectedDataIds = byteArrayOf(
        XsensDotRecordingManager.RECORDING_DATA_ID_TIMESTAMP,
        XsensDotRecordingManager.RECORDING_DATA_ID_EULER_ANGLES,
        XsensDotRecordingManager.RECORDING_DATA_ID_CALIBRATED_ACC,
        XsensDotRecordingManager.RECORDING_DATA_ID_CALIBRATED_GYR
    )

    init {
        exportingManager = XsensDotRecordingManager(context, device, this)
    }

    fun enableDataRecordingNotification() {
        SystemClock.sleep(sleepingTimeMs)
        exportingManager.enableDataRecordingNotification()
    }

    fun extractFile(info: XsensDotRecordingFileInfo): Boolean {
        if (!selectDataIds()) return false
        SystemClock.sleep(sleepingTimeMs)
        return exportingManager.startExporting(arrayListOf(info))
    }

    fun getFlashInfo() {
        Log.i("XSensDot", "Is notification enable $isNotificationEnabled")
        if (isNotificationEnabled) {
            SystemClock.sleep(sleepingTimeMs)
            exportingManager.requestFlashInfo()
        }
    }

    fun getFileInfo() {
        Log.i("XSensDot", "Is notification enable $isNotificationEnabled")
        if (isNotificationEnabled) {
            SystemClock.sleep(sleepingTimeMs)
            exportingManager.requestFileInfo()
        }
    }

    fun clearManager() {
        exportingManager.clear()
    }

    private fun selectDataIds(): Boolean {
        return exportingManager.selectExportedData(selectedDataIds)
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
        Log.i("XSensDot", "$usedFlashSpace $totalFlashSpace")
        XSensDotRecordingStreamHandler.sendEvent(RecordingEvent(RecordingStatus.GetFlashInfoDone))
    }

    override fun onXsensDotRecordingAck(
        address: String?,
        recordingId: Int,
        isSuccess: Boolean,
        recordingState: XsensDotRecordingState?
    ) {}

    override fun onXsensDotGetRecordingTime(
        address: String?,
        startUTCSeconds: Int,
        totalRecordingSeconds: Int,
        remainingRecordingSeconds: Int
    ) {}

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
                XSensFileInfoSerializer.serialize(fileInfoList[fileInfoList.size - 1])
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