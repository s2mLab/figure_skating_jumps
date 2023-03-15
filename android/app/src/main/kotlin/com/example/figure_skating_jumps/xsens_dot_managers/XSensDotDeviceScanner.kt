package com.example.figure_skating_jumps.xsens_dot_managers

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanSettings
import android.content.Intent
import android.util.Log
import com.example.figure_skating_jumps.MainActivity
import com.example.figure_skating_jumps.channels.event_channels.XSensDotScanStreamHandler
import com.xsens.dot.android.sdk.interfaces.XsensDotScannerCallback
import com.xsens.dot.android.sdk.utils.XsensDotScanner

class XSensDotDeviceScanner(mainActivity: MainActivity) : XsensDotScannerCallback {
    private var mainActivity: MainActivity? = mainActivity
    private var mXsScanner: XsensDotScanner = XsensDotScanner(mainActivity, this)

    override fun onXsensDotScanned(device: BluetoothDevice?, rssi: Int) {
        if (device?.address != null) {
                XSensDotScanStreamHandler.sendEvent(device)
        }
    }

    fun startScan() {
        //TODO remove when requesting bluetooth permissions
        val activity = mainActivity?.context as Activity

        val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)

        try {
            activity.startActivityForResult(intent, 1)
        }
        catch (e: SecurityException) {
            Log.e("Android", e.message!!)
        }
        mXsScanner.setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
        mXsScanner.startScan()
    }

    fun stopScan() {
        mXsScanner.stopScan()
    }
}