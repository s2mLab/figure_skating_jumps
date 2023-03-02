package com.example.figure_skating_jumps

import android.content.Context
import android.util.Log
import com.xsens.dot.android.sdk.events.XsensDotData
import com.xsens.dot.android.sdk.interfaces.XsensDotRecordingCallback
import com.xsens.dot.android.sdk.models.XsensDotDevice
import com.xsens.dot.android.sdk.models.XsensDotRecordingFileInfo
import com.xsens.dot.android.sdk.models.XsensDotRecordingState
import com.xsens.dot.android.sdk.recording.XsensDotRecordingManager
import kotlinx.coroutines.runBlocking
import java.util.ArrayList

class RecordingFragment: XsensDotRecordingCallback {
    private var mManager: XsensDotRecordingManager
    private var canGetList: Boolean = false
    private var canRecord: Boolean = false

    constructor(context: Context, xsensDotDevice: XsensDotDevice) {
        mManager = XsensDotRecordingManager(context, xsensDotDevice, RecordingFragment@this)
    }

    fun startRecording() {
        mManager.requestFlashInfo()

        

        if (canRecord) {
            mManager.startRecording()
        }
    }

    fun stopRecording() {
        mManager.stopRecording()
//        mManager.requestFlashInfo()
//        canGetList = false
//        while(!canGetList) { }
//        mManager.requestFileInfo()
    }

    override fun onXsensDotRecordingNotification(p0: String?, p1: Boolean) {
        Log.i("XSensDot", "onXsensDotRecordingNotification")
        if (p1) {
            mManager.requestFlashInfo();
        }
    }

    override fun onXsensDotEraseDone(p0: String?, p1: Boolean) {
        Log.i("XSensDot", "onXsensDotEraseDone")
    }

    override fun onXsensDotRequestFlashInfoDone(p0: String?, p1: Int, p2: Int) {
        Log.i("XSensDot", "onXsensDotRequestFlashInfoDone")
        val usedFlashSpace: Int = p1
        val totalFlashSpace: Int = p2
        canRecord = usedFlashSpace / totalFlashSpace < 0.9
    }

    override fun onXsensDotRecordingAck(
        p0: String?,
        p1: Int,
        p2: Boolean,
        p3: XsensDotRecordingState?
    ) {
        if (p1 == XsensDotRecordingManager.RECORDING_ID_START_RECORDING) {
            Log.i("XSensDot", "start CallBack")
        } else if (p1 == XsensDotRecordingManager.RECORDING_ID_STOP_RECORDING) {
            Log.i("XSensDot", "stop CallBack")
            mManager.requestFileInfo()
//            canGetList = true
        }
    }

    override fun onXsensDotGetRecordingTime(p0: String?, p1: Int, p2: Int, p3: Int) {
        Log.i("XSensDot", "onXsensDotGetRecordingTime")
    }

    override fun onXsensDotRequestFileInfoDone(
        p0: String?,
        p1: ArrayList<XsensDotRecordingFileInfo>?,
        p2: Boolean
    ) {
        Log.i("XSensDot", p0!!)
        if (p1 == null || p1!!.isEmpty()) {
            Log.i("XSensDot", p1?.size.toString())
            return
        }
        Log.i("XSensDot", p1?.get(p1.size - 1)!!.fileName)
    }

    override fun onXsensDotDataExported(
        p0: String?,
        p1: XsensDotRecordingFileInfo?,
        p2: XsensDotData?
    ) {
        Log.i("XSensDot", "onXsensDotDataExported")
    }

    override fun onXsensDotDataExported(p0: String?, p1: XsensDotRecordingFileInfo?) {
        Log.i("XSensDot", "onXsensDotDataExported")
    }

    override fun onXsensDotAllDataExported(p0: String?) {
        Log.i("XSensDot", "onXsensDotAllDataExported")
    }

    override fun onXsensDotStopExportingData(p0: String?) {
        Log.i("XSensDot", "onXsensDotStopExportingData")
    }
}