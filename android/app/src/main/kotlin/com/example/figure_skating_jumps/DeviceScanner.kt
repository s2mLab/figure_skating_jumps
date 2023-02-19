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

    fun startScan() {
        listDevice.clear();
        mXsScanner = XsensDotScanner(mainActivity, this)

        mXsScanner!!.setScanMode(ScanSettings.SCAN_MODE_BALANCED)

        val activity = mainActivity?.context as Activity

        val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
        if (ActivityCompat.checkSelfPermission(
                mainActivity!!.context,
                Manifest.permission.BLUETOOTH_SCAN
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }

        activity.startActivityForResult(intent, 1)
        mXsScanner!!.startScan()
    }

    fun stopScan(): MutableList<String?> {
        mXsScanner?.stopScan()

        // return listDevice
        return listDevice
    }
}