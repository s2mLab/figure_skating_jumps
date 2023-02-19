package com.example.figure_skating_jumps

import android.Manifest
import android.app.Activity
import android.app.appsearch.StorageInfo
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanSettings
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.app.ActivityCompat
import com.xsens.dot.android.sdk.interfaces.XsensDotScannerCallback
import com.xsens.dot.android.sdk.utils.XsensDotScanner

class DeviceScanner(mainActivity: MainActivity) : XsensDotScannerCallback {
    private var mainActivity: MainActivity? = mainActivity
    private var mXsScanner: XsensDotScanner? = null
    private var listDevice = mutableListOf<String?>()

    override fun onXsensDotScanned(p0: BluetoothDevice?, p1: Int) {
        if (p0?.address != null && !listDevice.contains(p0?.address)) {
            listDevice.add(p0?.address)
        }
    }

    fun getDevices(): Any? {
        listDevice.clear();
        mXsScanner = XsensDotScanner(mainActivity, this)

        if (mXsScanner == null) {
            return null
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
        mXsScanner!!.startScan()

        // timer

        // stop scan
        mXsScanner?.stopScan()

        // return listDevice
        return listDevice
    }
}