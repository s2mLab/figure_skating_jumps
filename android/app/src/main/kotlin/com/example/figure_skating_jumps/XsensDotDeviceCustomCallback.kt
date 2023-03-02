package com.example.figure_skating_jumps

import android.util.Log
import com.xsens.dot.android.sdk.events.XsensDotData
import com.xsens.dot.android.sdk.interfaces.XsensDotDeviceCallback
import com.xsens.dot.android.sdk.models.FilterProfileInfo
import java.util.ArrayList
class XsensDotDeviceCustomCallback: XsensDotDeviceCallback {
    val currentData: CustomXsensDotData? = null

    override fun onXsensDotConnectionChanged(p0: String?, p1: Int) {
        Log.i("XSensDot", "onXsensDotConnectionChanged")
    }

    override fun onXsensDotServicesDiscovered(p0: String?, p1: Int) {
        Log.i("XSensDot", "onXsensDotServicesDiscovered")
    }

    override fun onXsensDotFirmwareVersionRead(p0: String?, p1: String?) {
        Log.i("XSensDot", "onXsensDotFirmwareVersionRead")
    }

    override fun onXsensDotTagChanged(p0: String?, p1: String?) {
        Log.i("XSensDot", "onXsensDotTagChanged")
    }

    override fun onXsensDotBatteryChanged(p0: String?, p1: Int, p2: Int) {
        Log.i("XSensDot", "onXsensDotBatteryChanged")
    }

    override fun onXsensDotDataChanged(p0: String?, p1: XsensDotData?) {
        val currentData = CustomXsensDotData(p1)
        Log.i("XSensDot", p1?.acc?.get(0).toString())
    }

    override fun onXsensDotInitDone(p0: String?) {
        Log.i("XSensDot", "onXsensDotInitDone")
    }

    override fun onXsensDotButtonClicked(p0: String?, p1: Long) {
        Log.i("XSensDot", "onXsensDotButtonClicked")
    }

    override fun onXsensDotPowerSavingTriggered(p0: String?) {
        Log.i("XSensDot", "onXsensDotPowerSavingTriggered")
    }

    override fun onReadRemoteRssi(p0: String?, p1: Int) {
        Log.i("XSensDot", "onReadRemoteRssi")
    }

    override fun onXsensDotOutputRateUpdate(p0: String?, p1: Int) {
        Log.i("XSensDot", "onXsensDotOutputRateUpdate")
    }

    override fun onXsensDotFilterProfileUpdate(p0: String?, p1: Int) {
        Log.i("XSensDot", "onXsensDotFilterProfileUpdate")
    }

    override fun onXsensDotGetFilterProfileInfo(p0: String?, p1: ArrayList<FilterProfileInfo>?) {
        Log.i("XSensDot", "onXsensDotGetFilterProfileInfo")
    }

    override fun onSyncStatusUpdate(p0: String?, p1: Boolean) {
        Log.i("XSensDot", "onSyncStatusUpdate")
    }
}