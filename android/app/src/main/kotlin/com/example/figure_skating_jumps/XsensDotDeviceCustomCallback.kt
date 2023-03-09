package com.example.figure_skating_jumps

import android.util.Log
import com.xsens.dot.android.sdk.events.XsensDotData
import com.xsens.dot.android.sdk.interfaces.XsensDotDeviceCallback
import com.xsens.dot.android.sdk.models.FilterProfileInfo
import com.xsens.dot.android.sdk.models.XsensDotDevice
import java.util.ArrayList
class XsensDotDeviceCustomCallback: XsensDotDeviceCallback {
    val currentData: CustomXsensDotData? = null

    override fun onXsensDotConnectionChanged(address: String?, state: Int) {
        Log.i("XSensDot", "onXsensDotConnectionChanged")
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
    }

    override fun onXsensDotDataChanged(address: String?, data: XsensDotData?) {
        val currentData = CustomXsensDotData(data)
        Log.i("XSensDot", "Acceleration data:${data?.acc} Array Size: ${data?.acc?.size}")
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