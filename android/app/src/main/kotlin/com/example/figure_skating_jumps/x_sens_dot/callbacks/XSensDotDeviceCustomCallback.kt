package com.example.figure_skating_jumps.x_sens_dot.callbacks

import android.util.Log
import com.example.figure_skating_jumps.channels.event_channels.XSensDotConnectionStreamHandler
import com.example.figure_skating_jumps.channels.event_channels.XSensDotMeasuringStatusStreamHandler
import com.example.figure_skating_jumps.channels.event_channels.XSensDotMeasuringStreamHandler
import com.example.figure_skating_jumps.channels.event_channels.XSensDotRecordingStreamHandler
import com.example.figure_skating_jumps.channels.events.RecordingEvent
import com.example.figure_skating_jumps.x_sens_dot.CustomXSensDotData
import com.example.figure_skating_jumps.x_sens_dot.enums.MeasuringStatus
import com.example.figure_skating_jumps.x_sens_dot.enums.RecordingStatus
import com.xsens.dot.android.sdk.events.XsensDotData
import com.xsens.dot.android.sdk.interfaces.XsensDotDeviceCallback
import com.xsens.dot.android.sdk.models.FilterProfileInfo
import com.xsens.dot.android.sdk.models.XsensDotDevice
import java.util.ArrayList

/**
 * A class that implements the [XsensDotDeviceCallback] abstract class. This class handles
 * the data received from the XSens Dot
 */
class XSensDotDeviceCustomCallback : XsensDotDeviceCallback {
    private val maxRecordingOutputRate: Int = 120
    private val measuringOutputRate: Int = 12

    /*The XSensDotDevice contains 5 connection state (int),
    * but we need to know when it is ready to use,
    * hence the initializedState. The 3 was the value that was not used.
    * CONN_STATE_DISCONNECTED = 0
    * CONN_STATE_CONNECTING = 1
    * CONN_STATE_CONNECTED = 2
    * initializedState = 3
    * CONN_STATE_RECONNECTING = 4
    * CONN_STATE_START_RECONNECTING = 5
    */
    private val initializedState: Int = 3

    /**
     * Overrides the connection changed callback. Sends the new connection state
     * to the flutter project
     *
     * @param address The XSens Dot MAC address
     * @param state The new connection state
     */
    override fun onXsensDotConnectionChanged(address: String?, state: Int) {
        // Log.i("XSensDot", "onXsensDotConnectionChanged")
        XSensDotConnectionStreamHandler.sendEvent(state)
        if (state == XsensDotDevice.CONN_STATE_CONNECTED) {
            // Log.i("XSensDot", "Connected to $address")
        } else if (state == XsensDotDevice.CONN_STATE_DISCONNECTED) {
            // Log.i("XSensDot", "Disconnected from $address")
        }
    }

    /**
     * Overrides the initialization done callback. Sends a notification that
     * the XSens Dot initialization is done to the flutter project
     *
     * @param address The XSens Dot MAC address
     */
    override fun onXsensDotInitDone(address: String?) {
        // Log.i("XSensDot", "Initialization of device $address complete")
        XSensDotConnectionStreamHandler.sendEvent(initializedState)
        XSensDotMeasuringStatusStreamHandler.sendEvent(MeasuringStatus.InitDone);
    }

    /**
     * Overrides the output rate update callback. Sends a notification that
     * the output rate is set to the flutter project
     *
     * @param address The XSens Dot MAC address
     * @param outputRate The new output rate
     */
    override fun onXsensDotOutputRateUpdate(address: String?, outputRate: Int) {
        // Log.i("XSensDot", "Updated output rate of device $address to $outputRate Hz")
        if (outputRate == maxRecordingOutputRate) {
            XSensDotRecordingStreamHandler.sendEvent(RecordingEvent(RecordingStatus.SetRate))
        }
        if (outputRate == measuringOutputRate) {
            XSensDotMeasuringStatusStreamHandler.sendEvent(MeasuringStatus.SetRate);
        }
    }

    /**
     * Overrides the measuring callback. Sends a measuring event to the flutter project
     *
     * @param address The XSens Dot MAC address
     * @param data The measured Data
     */
    override fun onXsensDotDataChanged(address: String?, data: XsensDotData?) {
        val customXSensDotData = CustomXSensDotData(data)
        XSensDotMeasuringStreamHandler.sendEvent(customXSensDotData)
        // Log.i("XSensDot", "Received live data from $address : $customXSensDotData")
    }

    /**
     * XSens Dot synchronisation callback, not implemented
     */
    override fun onSyncStatusUpdate(address: String?, isSynced: Boolean) {
        Log.i("XSensDot", "onSyncStatusUpdate")
    }

    /**
     * Service discovery callback, not implemented
     */
    override fun onXsensDotServicesDiscovered(address: String?, status: Int) {
        Log.i("XSensDot", "onXsensDotServicesDiscovered")
    }

    /**
     * Read Firmware callback, not implemented
     */
    override fun onXsensDotFirmwareVersionRead(address: String?, version: String?) {
        Log.i("XSensDot", "onXsensDotFirmwareVersionRead")
    }

    /**
     * Tag changed callback, not implemented
     */
    override fun onXsensDotTagChanged(address: String?, tag: String?) {
        Log.i("XSensDot", "onXsensDotTagChanged")
    }

    /**
     * XSens Dot Battery changed callback, not implemented
     */
    override fun onXsensDotBatteryChanged(address: String?, status: Int, percentage: Int) {
        Log.i("XSensDot", "onXsensDotBatteryChanged")
    }

    /**
     * XSens Dot button clicked callback, not implemented
     */
    override fun onXsensDotButtonClicked(address: String?, timestamp: Long) {
        Log.i("XSensDot", "onXsensDotButtonClicked")
    }

    /**
     * Power Saving callback, not implemented
     */
    override fun onXsensDotPowerSavingTriggered(address: String?) {
        Log.i("XSensDot", "onXsensDotPowerSavingTriggered")
    }

    /**
     * Read RSSI callback, not implemented
     */
    override fun onReadRemoteRssi(address: String?, rssi: Int) {
        Log.i("XSensDot", "onReadRemoteRssi")
    }

    /**
     * Filter Profile Update callback, not implemented
     */
    override fun onXsensDotFilterProfileUpdate(address: String?, filterProfileIndex: Int) {
        Log.i("XSensDot", "onXsensDotFilterProfileUpdate")
    }

    /**
     * Filter Profile Info callback, not implemented
     */
    override fun onXsensDotGetFilterProfileInfo(
        address: String?,
        filterProfileInfoList: ArrayList<FilterProfileInfo>?
    ) {
        Log.i("XSensDot", "onXsensDotGetFilterProfileInfo")
    }
}