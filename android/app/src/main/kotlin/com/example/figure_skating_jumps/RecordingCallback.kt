package com.example.figure_skating_jumps

import android.content.Context
import android.util.Log
import com.xsens.dot.android.sdk.events.XsensDotData
import com.xsens.dot.android.sdk.interfaces.XsensDotRecordingCallback
import com.xsens.dot.android.sdk.models.XsensDotDevice
import com.xsens.dot.android.sdk.models.XsensDotRecordingFileInfo
import com.xsens.dot.android.sdk.models.XsensDotRecordingState
import com.xsens.dot.android.sdk.recording.XsensDotRecordingManager
import java.util.ArrayList

class RecordingCallback(context: Context, xsensDotDevice: XsensDotDevice) : XsensDotRecordingCallback {
    private var mManager: XsensDotRecordingManager
    private var canRecord: Boolean = false

    init {
        mManager = XsensDotRecordingManager(context, xsensDotDevice, this)
    }

    fun startRecording() {
        //mManager.requestFlashInfo()

        //if (canRecord) {
            mManager.startRecording()
        //}
    }

    fun stopRecording() {
        mManager.stopRecording()
//        mManager.requestFlashInfo()
//        canGetList = false
//        while(!canGetList) { }
//        mManager.requestFileInfo()
    }

    override fun onXsensDotRecordingNotification(address: String?, isSuccess: Boolean) {
        Log.i("XSensDot", "onXsensDotRecordingNotification")
        if (isSuccess) {
            mManager.requestFlashInfo();
        }
    }

    override fun onXsensDotEraseDone(address: String?, p1: Boolean) {
        Log.i("XSensDot", "onXsensDotEraseDone")
    }

    override fun onXsensDotRequestFlashInfoDone(address: String?, usedFlashSpace: Int,totalFlashSpace: Int) {
        Log.i("XSensDot", "onXsensDotRequestFlashInfoDone")
        canRecord = usedFlashSpace / totalFlashSpace < 0.9
    }

    override fun onXsensDotRecordingAck(
        address: String?,
        recordingId: Int,
        isSuccess: Boolean,
        recordingState: XsensDotRecordingState?
    ) {
        if (recordingId == XsensDotRecordingManager.RECORDING_ID_START_RECORDING) {
            Log.i("XSensDot", "start CallBack")
        } else if (recordingId == XsensDotRecordingManager.RECORDING_ID_STOP_RECORDING) {
            Log.i("XSensDot", "stop CallBack")
            mManager.requestFileInfo()
//            canGetList = true
        }
    }

    override fun onXsensDotGetRecordingTime(address: String?, startUTCSeconds: Int, totalRecordingSeconds: Int, remainingRecordingSeconds: Int) {
        Log.i("XSensDot", "onXsensDotGetRecordingTime")
    }

    override fun onXsensDotRequestFileInfoDone(
        address: String?,
        fileInfoList: ArrayList<XsensDotRecordingFileInfo>?,
        isSuccess: Boolean
    ) {
        Log.i("XSensDot", address!!)
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