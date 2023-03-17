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
        Log.i("XSensDot", "Enable data notification called")
        //TODO this condition does not seem to work properly
        while (device.connectionState == XsensDotDevice.CONN_STATE_CONNECTING
            || device.connectionState == XsensDotDevice.CONN_STATE_RECONNECTING
        ) {
            Log.i("XSensDot", "Waiting 30ms for connection...")
            SystemClock.sleep(30)
        }
        if (device.connectionState != XsensDotDevice.CONN_STATE_CONNECTED) {
            Log.i("XSensDot", "Device not connected - ${device.connectionState}")
            return
        }
        SystemClock.sleep(30)
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
        Log.i("XSensDot", "Recording Notif Recorder state $recorderState")
        isNotificationEnabled = isEnabled
        if (!isEnabled) return
        if(recorderState == RecorderState.preparingExport) {
            SystemClock.sleep(30)
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

        Log.i("XSensDot", "Recording Ack Recorder state $recorderState")
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
        //THE MANAGER does not make call to device when in call back...
        Log.i("XSensDot", "Request File Info Recorder state $recorderState")
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
            val toExport = arrayListOf(fileInfoList[0])
            recorderState = RecorderState.exporting
            recordingManager.startExporting(toExport)
        }
    }

    override fun onXsensDotDataExported(
        address: String?,
        fileInfo: XsensDotRecordingFileInfo?,
        exportedData: XsensDotData?
    ) {
        Log.i("XSensDot", "Data Export (3args) Recorder state $recorderState")
        Log.i("XSensDot", "Exported this data ${exportedData?.packetCounter}")
        //TODO remonter event pour faire le fichier dans flutter
    }

    override fun onXsensDotDataExported(address: String?, fileInfo: XsensDotRecordingFileInfo?) {
        Log.i("XSensDot", "onXsensDotDataExported")
        Log.i("XSensDot", "Data Export(2args) Recorder state $recorderState")
        //TODO remonter event pour faire le fichier dans flutter
    }

    override fun onXsensDotAllDataExported(address: String?) {
        Log.i("XSensDot", "I am done exporting!")
        Log.i("XSensDot", "All exportRecorder state $recorderState")
        if(recorderState == RecorderState.exporting) {
            recorderState = RecorderState.idle
            //TODO remonter event pour enregistrer dans flutter
        }
    }

    override fun onXsensDotStopExportingData(address: String?) {
        Log.i("XSensDot", "onXsensDotStopExportingData")
    }

    private fun prepareDataExport() {
        Log.i("XSensDot", "Prepare export Recorder state $recorderState")
        Log.i("XSensDot", "Prepare export Notification status $isNotificationEnabled")
        recorderState = RecorderState.preparingExport
        if(isNotificationEnabled) {
            SystemClock.sleep(30)
            recordingManager.requestFileInfo()
        }
        else {
            enableDataRecordingNotification()
        }
    }
}