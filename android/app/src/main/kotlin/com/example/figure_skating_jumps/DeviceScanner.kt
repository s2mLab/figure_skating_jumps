package com.example.figure_skating_jumps

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanSettings
import android.content.Intent
import android.util.Log
import com.xsens.dot.android.sdk.interfaces.XsensDotScannerCallback
import com.xsens.dot.android.sdk.models.XsensDotDevice
import com.xsens.dot.android.sdk.utils.XsensDotScanner

class DeviceScanner(mainActivity: MainActivity) : XsensDotScannerCallback {
    private var mainActivity: MainActivity? = mainActivity
    private var mXsScanner: XsensDotScanner = XsensDotScanner(mainActivity, this)
    private var devicesInfo = mutableListOf<Pair<String?, String?>>()

    override fun onXsensDotScanned(p0: BluetoothDevice?, p1: Int) {
        if (p0?.address != null  && !devicesInfo.any {it.first == p0.address }) {
            try {
                devicesInfo.add(Pair(p0.address, p0.name ))
                val xsensDotDeviceCB = XsensDotDeviceCB()
            }
            catch (e: SecurityException) {
                Log.e("Android", e.message!!)
            }
        }
    }

    fun startScan() {
        devicesInfo.clear()
        mXsScanner.setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)

        val activity = mainActivity?.context as Activity

        val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)

        try {
            activity.startActivityForResult(intent, 1)
        }
        catch (e: SecurityException) {
            Log.e("Android", e.message!!)
        }
        mXsScanner.startScan()
    }

    fun stopScan(): MutableList<Pair<String?, String?>> {
        mXsScanner.stopScan()

        // return listDevice
        return devicesInfo
    }
}