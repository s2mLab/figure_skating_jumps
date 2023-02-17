package com.example.figure_skating_jumps

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanSettings
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import com.xsens.dot.android.sdk.interfaces.XsensDotScannerCallback
import com.xsens.dot.android.sdk.utils.XsensDotScanner

class DeviceScanner(mainActivity: MainActivity) : XsensDotScannerCallback {
    private var mainActivity: MainActivity? = mainActivity
    private var mXsScanner: XsensDotScanner? = null

    override fun onXsensDotScanned(p0: BluetoothDevice?, p1: Int) {
        if (mainActivity?.let {
                ActivityCompat.checkSelfPermission(
                    it.context,
                    Manifest.permission.BLUETOOTH_CONNECT
                )
            } != PackageManager.PERMISSION_GRANTED
        ) {
            val name = p0?.name
            val address = p0?.address
        }
    }

    fun getDevices(): String {
        mXsScanner = XsensDotScanner(mainActivity, this)

        if (mXsScanner == null) {
            return "scanner null"
        }

        mXsScanner!!.setScanMode(ScanSettings.SCAN_MODE_BALANCED)

        //var activity = Activity()
        val activity = mainActivity?.context as Activity
//        requestScanningPermission(activity, 1)

        val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
        if (ActivityCompat.checkSelfPermission(
                mainActivity!!.context,
                Manifest.permission.BLUETOOTH_SCAN
            ) != PackageManager.PERMISSION_GRANTED
        ) {
        }
        activity.startActivityForResult(intent, 1)
        mXsScanner!!.startScan();

        return "scan"
    }
}