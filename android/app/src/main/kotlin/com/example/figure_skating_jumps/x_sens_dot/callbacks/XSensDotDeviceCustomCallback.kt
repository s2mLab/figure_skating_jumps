package com.example.figure_skating_jumps.x_sens_dot.callbacks

import android.util.Log
import com.example.figure_skating_jumps.channels.event_channels.XSensDotConnectionStreamHandler
import com.example.figure_skating_jumps.channels.event_channels.XSensDotMeasuringStreamHandler
import com.example.figure_skating_jumps.channels.event_channels.XSensDotRecordingStreamHandler
import com.example.figure_skating_jumps.channels.events.RecordingEvent
import com.example.figure_skating_jumps.x_sens_dot.CustomXSensDotData
import com.example.figure_skating_jumps.x_sens_dot.enums.RecordingStatus
import com.xsens.dot.android.sdk.events.XsensDotData
import com.xsens.dot.android.sdk.interfaces.XsensDotDeviceCallback
import com.xsens.dot.android.sdk.models.FilterProfileInfo
import com.xsens.dot.android.sdk.models.XsensDotDevice
import java.util.ArrayList
class XSensDotDeviceCustomCallback: XsensDotDeviceCallback {
    private val maxRecordingOutputRate: Int = 120

    override fun onXsensDotConnectionChanged(address: String?, state: Int) {
        Log.i("XSensDot", "onXsensDotConnectionChanged")
        XSensDotConnectionStreamHandler.sendEvent(state)
        if(state == XsensDotDevice.CONN_STATE_CONNECTED) {
            Log.i("XSensDot", "Connected to $address")
        } else if(state == XsensDotDevice.CONN_STATE_DISCONNECTED) {
            Log.i("XSensDot", "Disconnected from $address")
        }
    }

    override fun onXsensDotInitDone(address: String?) {
        Log.i("XSensDot", "Initialization of device $address complete")
    }

    override fun onXsensDotOutputRateUpdate(address: String?, outputRate: Int) {
        Log.i("XSensDot", "Updated output rate of device $address to $outputRate Hz")
        if(outputRate == maxRecordingOutputRate ) {
            XSensDotRecordingStreamHandler.sendEvent(RecordingEvent(RecordingStatus.SetRate))
        }
    }

    override fun onXsensDotDataChanged(address: String?, data: XsensDotData?) {
        val customXSensDotData = CustomXSensDotData(data)
        XSensDotMeasuringStreamHandler.sendEvent(customXSensDotData)
        Log.i("XSensDot", "Received live data from $address : $customXSensDotData")
    }

    override fun onSyncStatusUpdate(address: String?, isSynced: Boolean) {
        Log.i("XSensDot", "onSyncStatusUpdate")
    }

    override fun onXsensDotServicesDiscovered(address: String?, status: Int) {
        Log.i("XSensDot", "onXsensDotServicesDiscovered")
    }

    override fun onXsensDotFirmwareVersionRead(address: String?, version: String?) {
        Log.i("XSensDot", "onXsensDotFirmwareVersionRead")
    }

    override fun onXsensDotTagChanged(address: String?, tag: String?) {
        Log.i("XSensDot", "onXsensDotTagChanged")
    }

    override fun onXsensDotBatteryChanged(address: String?, status: Int, percentage: Int) {
        Log.i("XSensDot", "onXsensDotBatteryChanged")
    }

    override fun onXsensDotButtonClicked(address: String?, timestamp: Long) {
        Log.i("XSensDot", "onXsensDotButtonClicked")
    }

    override fun onXsensDotPowerSavingTriggered(address: String?) {
        Log.i("XSensDot", "onXsensDotPowerSavingTriggered")
    }

    override fun onReadRemoteRssi(address: String?, rssi: Int) {
        Log.i("XSensDot", "onReadRemoteRssi")
    }

    override fun onXsensDotFilterProfileUpdate(address: String?, filterProfileIndex: Int) {
        Log.i("XSensDot", "onXsensDotFilterProfileUpdate")
    }

    override fun onXsensDotGetFilterProfileInfo(address: String?, filterProfileInfoList: ArrayList<FilterProfileInfo>?) {
        Log.i("XSensDot", "onXsensDotGetFilterProfileInfo")
    }
}