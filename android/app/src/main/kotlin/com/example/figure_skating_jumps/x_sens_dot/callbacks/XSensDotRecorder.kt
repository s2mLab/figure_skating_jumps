package com.example.figure_skating_jumps.x_sens_dot.callbacks

import android.content.Context
import android.os.SystemClock
import android.util.Log
import com.example.figure_skating_jumps.x_sens_dot.enums.RecorderState
import com.xsens.dot.android.sdk.events.XsensDotData
import com.xsens.dot.android.sdk.interfaces.XsensDotRecordingCallback
import com.xsens.dot.android.sdk.models.XsensDotDevice
import com.xsens.dot.android.sdk.models.XsensDotRecordingFileInfo
import com.xsens.dot.android.sdk.models.XsensDotRecordingState
import com.xsens.dot.android.sdk.recording.XsensDotRecordingManager
import kotlin.collections.ArrayList

class XSensDotRecorder(context: Context, xsensDotDevice: XsensDotDevice) :
    XsensDotRecordingCallback {
    private var recordingManager: XsensDotRecordingManager
    private var canRecord: Boolean = false
    private var isNotificationEnabled: Boolean = false
    private var device: XsensDotDevice
    private var recorderState: RecorderState = RecorderState.idle

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
        Log.i("XSensDot", "Im called")
        while (device.connectionState == XsensDotDevice.CONN_STATE_CONNECTING
            || device.connectionState == XsensDotDevice.CONN_STATE_RECONNECTING
        ) {
            SystemClock.sleep(30)
        }
        if (device.connectionState != XsensDotDevice.CONN_STATE_CONNECTED) {
            Log.i("XSensDot", "Device not connected - ${device.connectionState}")
            return
        }
        recordingManager.enableDataRecordingNotification()
    }

    fun getFileInfo() {
        enableDataRecordingNotification()
        Log.i("XSensDot", "isActive ${recordingManager.isActive} recordState ${recordingManager.recordingState}")
        Log.i("XSensDot", "Is notification enable $isNotificationEnabled")
        if (isNotificationEnabled) {
            SystemClock.sleep(30)
            recordingManager.requestFileInfo()
        }

    }

    override fun onXsensDotRecordingNotification(address: String?, isEnabled: Boolean) {
        Log.i("XSensDot", "onXsensDotRecordingNotification")
        Log.i("XSensDot", "Notification Enabled $isEnabled")
        isNotificationEnabled = isEnabled
        if (!isEnabled) return
        if(recorderState == RecorderState.preparingExport) {
            recordingManager.requestFileInfo()
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
            XsensDotRecordingManager.RECORDING_ID_START_RECORDING -> {
                Log.i("XSensDot", "start CallBack")
                recorderState = RecorderState.recording
            }
            XsensDotRecordingManager.RECORDING_ID_STOP_RECORDING -> {
                Log.i("XSensDot", "stop CallBack")
                if(recorderState == RecorderState.recording) {
                    prepareDataExport()
                }
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
        if(!isSuccess) {
            Log.i("XSensDot", "File info request was not successful")
            return
        }
        if(fileInfoList == null || fileInfoList.isEmpty()){
            Log.i("XSensDot", "File info list is empty")
            return
        }
        if(recorderState == RecorderState.preparingExport){
            for (file in fileInfoList) {
                Log.i("XSensDot", file.fileName)
            }
            var toExport = arrayListOf<XsensDotRecordingFileInfo>(fileInfoList[0])
            recorderState = RecorderState.exporting
            recordingManager.startExporting(toExport)
        }
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
        //TODO remonter event pour faire le fichier dans flutter
    }

    override fun onXsensDotAllDataExported(address: String?) {
        Log.i("XSensDot", "I am done!")
        if(recorderState == RecorderState.exporting) {
            recorderState = RecorderState.idle
            //TODO remonter event pour enregistrer dans flutter
        }
    }

    override fun onXsensDotStopExportingData(address: String?) {
        Log.i("XSensDot", "onXsensDotStopExportingData")
    }

    private fun prepareDataExport() {
        recorderState = RecorderState.preparingExport
        if(isNotificationEnabled)
            recordingManager.requestFileInfo()
        else
            recordingManager.enableDataRecordingNotification()
    }
}