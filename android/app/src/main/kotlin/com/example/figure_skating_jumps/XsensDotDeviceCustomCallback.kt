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

    override fun onXsensDotDataChanged(address: String?, data: XsensDotData?) {
        val currentData = CustomXsensDotData(data)
        Log.i("XSensDot", data?.acc?.get(0).toString())
    }

    override fun onXsensDotInitDone(address: String?) {
        Log.i("XSensDot", "onXsensDotInitDone")
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

    override fun onXsensDotOutputRateUpdate(address: String?, outputRate: Int) {
        Log.i("XSensDot", "onXsensDotOutputRateUpdate")
    }

    override fun onXsensDotFilterProfileUpdate(address: String?, filterProfileIndex: Int) {
        Log.i("XSensDot", "onXsensDotFilterProfileUpdate")
    }

    override fun onXsensDotGetFilterProfileInfo(address: String?, filterProfileInfoList: ArrayList<FilterProfileInfo>?) {
        Log.i("XSensDot", "onXsensDotGetFilterProfileInfo")
    }

    override fun onSyncStatusUpdate(address: String?, isSynced: Boolean) {
        Log.i("XSensDot", "onSyncStatusUpdate")
    }
}