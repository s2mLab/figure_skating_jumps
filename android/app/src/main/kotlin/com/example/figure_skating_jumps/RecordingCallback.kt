package com.example.figure_skating_jumps

import android.content.Context
import android.os.SystemClock
import android.util.Log
import com.xsens.dot.android.sdk.events.XsensDotData
import com.xsens.dot.android.sdk.interfaces.XsensDotRecordingCallback
import com.xsens.dot.android.sdk.models.XsensDotDevice
import com.xsens.dot.android.sdk.models.XsensDotRecordingFileInfo
import com.xsens.dot.android.sdk.models.XsensDotRecordingState
import com.xsens.dot.android.sdk.recording.XsensDotRecordingManager
import java.util.ArrayList

class RecordingCallback(context: Context, xsensDotDevice: XsensDotDevice) :
    XsensDotRecordingCallback {
    private var mManager: XsensDotRecordingManager
    private var canRecord: Boolean = false
    private var isNotificationEnabled: Boolean = false
    private var device: XsensDotDevice

    init {
        device = xsensDotDevice
        mManager = XsensDotRecordingManager(context, xsensDotDevice, this)
    }

    fun startRecording() {
        mManager.startRecording()
    }

    fun stopRecording() {
        mManager.stopRecording()
    }

    fun enableDataRecordingNotification() {
        Log.i("XSensDot", "Im called")
        while (device.connectionState == XsensDotDevice.CONN_STATE_CONNECTING
            || device.connectionState == XsensDotDevice.CONN_STATE_RECONNECTING) {
            SystemClock.sleep(30)
        }
        if (device.connectionState != XsensDotDevice.CONN_STATE_CONNECTED) {
            Log.i("XSensDot", "Device not connected - ${device.connectionState}")
            return
        }
        mManager.enableDataRecordingNotification()
    }
    fun getFileInfo() {
        enableDataRecordingNotification()
        Log.i("XSensDot", "WTF ${mManager.isActive} ${mManager.recordingState}")
        Log.i("XSensDot", "Is notification enable $isNotificationEnabled")
        if (isNotificationEnabled) {
            SystemClock.sleep(30)
            mManager.requestFileInfo()
        }

    }

    override fun onXsensDotRecordingNotification(address: String?, isEnabled: Boolean) {
        Log.i("XSensDot", "onXsensDotRecordingNotification")
        Log.i("XSensDot", "Notification Enabled $isEnabled")
        isNotificationEnabled = isEnabled
        if (isEnabled) {
            SystemClock.sleep(30)
            mManager.requestFlashInfo();
        }
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
        canRecord = usedFlashSpace / totalFlashSpace < 0.9
        Log.i("XsensDot", "canRecord - callback $canRecord")
    }

    override fun onXsensDotRecordingAck(
        address: String?,
        recordingId: Int,
        isSuccess: Boolean,
        recordingState: XsensDotRecordingState?
    ) {
        when (recordingId) {
            XsensDotRecordingManager.RECORDING_ID_START_RECORDING -> Log.i(
                "XSensDot",
                "start CallBack"
            )
            XsensDotRecordingManager.RECORDING_ID_STOP_RECORDING -> Log.i(
                "XSensDot",
                "stop CallBack"
            )
            XsensDotRecordingManager.RECORDING_ID_GET_STATE -> Log.i(
                "XSensDot",
                "Current state $recordingState"
            )
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
        Log.i("XSensDot", address!!)
        Log.i("XSensDot", fileInfoList.toString())
        Log.i("XSensDot", "$isSuccess")
        if (fileInfoList == null || fileInfoList.isEmpty()) {
            Log.i("XSensDot", fileInfoList?.size.toString())
            return
        }
        Log.i("XSensDot", fileInfoList[fileInfoList.size - 1].fileName)
    }

    override fun onXsensDotDataExported(
        address: String?,
        fileInfo: XsensDotRecordingFileInfo?,
        exportedData: XsensDotData?
    ) {
        Log.i("XSensDot", "onXsensDotDataExported")
    }

    override fun onXsensDotDataExported(address: String?, fileInfo: XsensDotRecordingFileInfo?) {
        Log.i("XSensDot", "onXsensDotDataExported")
    }

    override fun onXsensDotAllDataExported(address: String?) {
        Log.i("XSensDot", "onXsensDotAllDataExported")
    }

    override fun onXsensDotStopExportingData(address: String?) {
        Log.i("XSensDot", "onXsensDotStopExportingData")
    }
}