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
import com.xsens.dot.android.sdk.interfaces.XsensDotScannerCallback
import com.xsens.dot.android.sdk.models.XsensDotDevice
import com.xsens.dot.android.sdk.models.XsensDotRecordingFileInfo
import com.xsens.dot.android.sdk.models.XsensDotRecordingState
import com.xsens.dot.android.sdk.recording.XsensDotRecordingManager
import kotlin.collections.ArrayList

/**
 * A class that implements the [XsensDotRecordingCallback] abstract class. This class allows
 * to export and erase files from the XSens Dot memory
 *
 * @param context The application context
 * @param device The XSens Dot device to export from
 */
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

    /**
     * Enables the Data recording notifications on the device
     */
    fun enableDataRecordingNotification() {
        SystemClock.sleep(sleepingTimeMs)
        exportingManager.enableDataRecordingNotification()
    }

    /**
     * Start a file export
     *
     * @param info The info to identify the file to export
     */
    fun extractFile(info: XsensDotRecordingFileInfo): Boolean {
        if (!selectDataIds()) return false
        SystemClock.sleep(sleepingTimeMs)
        return exportingManager.startExporting(arrayListOf(info))
    }

    /**
     * Gets the flash memory info from the device
     */
    fun getFlashInfo() {
        Log.i("XSensDot", "Is notification enable $isNotificationEnabled")
        if (isNotificationEnabled) {
            SystemClock.sleep(sleepingTimeMs)
            exportingManager.requestFlashInfo()
        }
    }

    /**
     * Gets the files info from the device
     */
    fun getFileInfo() {
        Log.i("XSensDot", "Is notification enable $isNotificationEnabled")
        if (isNotificationEnabled) {
            SystemClock.sleep(sleepingTimeMs)
            exportingManager.requestFileInfo()
        }
    }

    /**
     * Clears the exporting manager
     */
    fun clearManager() {
        exportingManager.clear()
    }

    /**
     * Start to erase all data on the XSens Dot's flash memory
     */
    fun eraseMemory() {
        if (isNotificationEnabled) {
            SystemClock.sleep(sleepingTimeMs)
            Log.i("XSensDot", "Started erasing")
            exportingManager.eraseRecordingData()
        }
    }

    /**
     * Selects the data to export from a file
     */
    private fun selectDataIds(): Boolean {
        return exportingManager.selectExportedData(selectedDataIds)
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
     * Erase Memory callback. Sends an event to the flutter project
     * to notify the XSensDotRecordingService that the erasing is done
     *
     * @param address The XSens Dot device MAC address
     * @param isSuccess Whether or not the erasing was a success
     */
    override fun onXsensDotEraseDone(address: String?, isSuccess: Boolean) {
        Log.i("XSensDot", "onXsensDotEraseDone")
        XSensDotRecordingStreamHandler.sendEvent(
            RecordingEvent(
                RecordingStatus.EraseMemoryDone
            )
        )
    }

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
        XSensDotRecordingStreamHandler.sendEvent(RecordingEvent(RecordingStatus.GetFlashInfoDone))
    }

    /**
     * Request File Info callback. Sends an event to the flutter project
     * to notify the XSensDotRecordingService to export the last file info
     *
     * @param address The XSens Dot device MAC address
     * @param fileInfoList An [ArrayList] containing all the XSens Dot devices file info
     * @param isSuccess Whether or not the file info request was a success
     */
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

        XSensDotRecordingStreamHandler.sendEvent(
            RecordingEvent(
                RecordingStatus.GetFileInfoDone,
                XSensFileInfoSerializer.serialize(fileInfoList.last())
            )
        )

    }

    /**
     * Data Exported callback. Sends an event to the flutter project
     * to notify the XSensDotRecordingService to save the exported data
     *
     * @param address The XSens Dot device MAC address
     * @param fileInfo The file from which the data was extracted
     * @param exportedData The data to export and save
     */
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

    /**
     * Data Exported callback. Sends an event to the flutter project
     * to notify the XSensDotRecordingService that some data was exported
     *
     * @param address The XSens Dot device MAC address
     * @param fileInfo The file from which the data was extracted
     */
    override fun onXsensDotDataExported(address: String?, fileInfo: XsensDotRecordingFileInfo?) {
        Log.i("XSensDot", "onXsensDotDataExported")
        XSensDotRecordingStreamHandler.sendEvent(RecordingEvent(RecordingStatus.ExtractingFile))
    }

    /**
     * All Data Exported callback. Sends an event to the flutter project to notify
     * the XSensDotRecordingService that all data from a file were exported
     *
     * @param address The XSens Dot device MAC address
     */
    override fun onXsensDotAllDataExported(address: String?) {
        Log.i("XSensDot", "I am done exporting!")
        XSensDotRecordingStreamHandler.sendEvent(RecordingEvent(RecordingStatus.ExtractFileDone))
    }

    /**
     * Stop Exporting Data callback, not implemented
     */
    override fun onXsensDotStopExportingData(address: String?) {
        Log.i("XSensDot", "onXsensDotStopExportingData")
    }

    /**
     * Recording Acknowledge callback, not implemented
     */
    override fun onXsensDotRecordingAck(
        address: String?,
        recordingId: Int,
        isSuccess: Boolean,
        recordingState: XsensDotRecordingState?
    ) {
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
    }
}