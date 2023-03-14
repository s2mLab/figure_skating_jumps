package com.example.figure_skating_jumps.xsens_dot_managers

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanSettings
import android.content.Intent
import android.util.Log
import com.example.figure_skating_jumps.MainActivity
import com.xsens.dot.android.sdk.interfaces.XsensDotScannerCallback
import com.xsens.dot.android.sdk.utils.XsensDotScanner

class XSensDotDeviceScanner(mainActivity: MainActivity) : XsensDotScannerCallback {
    private var mainActivity: MainActivity? = mainActivity
    private var mXsScanner: XsensDotScanner = XsensDotScanner(mainActivity, this)
    private var devicesInfo = mutableListOf<Pair<String?, String?>>()

    override fun onXsensDotScanned(device: BluetoothDevice?, rssi: Int) {
        if (device?.address != null  && !devicesInfo.any {it.first == device.address }) {
            try {
                devicesInfo.add(Pair(device.address, device.alias ))
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