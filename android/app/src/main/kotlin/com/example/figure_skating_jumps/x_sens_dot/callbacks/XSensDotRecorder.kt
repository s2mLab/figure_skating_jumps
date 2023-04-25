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

/**
 * A class that implements the [XsensDotRecordingCallback] abstract class. This class allows
 * to record data with the XSens Dot
 *
 * @param context The application context
 * @param device The recording XSens Dot
 */
class XSensDotRecorder(context: Context, device: XsensDotDevice) :
    XsensDotRecordingCallback {
    private var recordingManager: XsensDotRecordingManager
    private var isNotificationEnabled: Boolean = false
    private val sleepingTimeMs: Long = 30
    private val maxUsedSpacePct: Double = 0.9

    init {
        recordingManager = XsensDotRecordingManager(context, device, this)
    }

    /**
     * Starts data recording on the XSens Dot
     */
    fun startRecording() {
        SystemClock.sleep(sleepingTimeMs)
        recordingManager.startRecording()
    }

    /**
     * Stops data recording on the XSens Dot
     */
    fun stopRecording() {
        SystemClock.sleep(sleepingTimeMs)
        recordingManager.stopRecording()
    }

    /**
     * Enables the Data recording notifications on the device
     */
    fun enableDataRecordingNotification() {
        SystemClock.sleep(sleepingTimeMs)
        recordingManager.enableDataRecordingNotification()
    }

    /**
     * Gets the flash memory info from the device
     */
    fun getFlashInfo() {
        Log.i("XSensDot", "Is notification enable $isNotificationEnabled")
        if (isNotificationEnabled) {
            SystemClock.sleep(sleepingTimeMs)
            recordingManager.requestFlashInfo()
        }
    }

    /**
     * Clears the recording manager
     */
    fun clearManager() {
        recordingManager.clear()
    }

    /**
     * Enable Recording Notification callback. Sends an event to the flutter project
     * to notify the XSensDotRecordingService on the recording notification status
     *
     * @param address The XSens Dot device MAC address
     * @param isEnabled whether or not the recording notification were enabled
     */
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

    /**
     * Erase Memory callback, not implemented
     */
    override fun onXsensDotEraseDone(address: String?, isSuccess: Boolean) {}

    /**
     * Request Flash Info callback. Sends an event to the flutter project
     * to notify the XSensDotRecordingService of the memory usage
     *
     * @param address The XSens Dot device MAC address
     * @param usedFlashSpace the used flash memory space
     * @param totalFlashSpace the total flash memory space
     */
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

    /**
     * Recording Acknowledge callback. Sends an event to the flutter project
     * to notify the XSensDotRecordingService of the new recording state
     *
     * @param address The XSens Dot device MAC address
     * @param recordingId The recording event Id
     * @param isSuccess Whether or not the acknowledge was a success
     * @param recordingState The recording state, null if not requested
     */
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

    /**
     * Get Recording Time callback, not implemented
     */
    override fun onXsensDotGetRecordingTime(
        address: String?,
        startUTCSeconds: Int,
        totalRecordingSeconds: Int,
        remainingRecordingSeconds: Int
    ) {
        Log.i("XSensDot", "onXsensDotGetRecordingTime")
    }

    /**
     * Request File Info callback, not implemented
     */
    override fun onXsensDotRequestFileInfoDone(
        address: String?,
        fileInfoList: ArrayList<XsensDotRecordingFileInfo>?,
        isSuccess: Boolean
    ) {}

    /**
     * Data Exported callback, not implemented
     */
    override fun onXsensDotDataExported(
        address: String?,
        fileInfo: XsensDotRecordingFileInfo?,
        exportedData: XsensDotData?
    ) {}

    /**
     * Data Exported callback, not implemented
     */
    override fun onXsensDotDataExported(address: String?, fileInfo: XsensDotRecordingFileInfo?) {}

    /**
     * All Data Exported callback, not implemented
     */
    override fun onXsensDotAllDataExported(address: String?) {}

    /**
     * Stop Exporting Data callback, not implemented
     */
    override fun onXsensDotStopExportingData(address: String?) {}
}