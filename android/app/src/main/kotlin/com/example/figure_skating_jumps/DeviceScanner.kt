package com.example.figure_skating_jumps

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanSettings
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import com.xsens.dot.android.sdk.interfaces.XsensDotScannerCallback
import com.xsens.dot.android.sdk.utils.XsensDotScanner

class DeviceScanner(mainActivity: MainActivity) : XsensDotScannerCallback {
    private var mainActivity: MainActivity? = mainActivity
    private var mXsScanner: XsensDotScanner? = null
    private var listDevice = mutableListOf<Pair<String?, String?>>()

    @RequiresApi(Build.VERSION_CODES.R)
    override fun onXsensDotScanned(p0: BluetoothDevice?, p1: Int) {
        if (p0?.address != null  && !listDevice.any {it.first == p0.address }) {

            if (ActivityCompat.checkSelfPermission(
                    mainActivity!!.context,
                    Manifest.permission.BLUETOOTH_CONNECT
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                return
            }

            listDevice.add(Pair(p0.address, p0.alias))
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

    fun stopScan(): MutableList<Pair<String?, String?>> {
        mXsScanner?.stopScan()

        // return listDevice
        return listDevice
    }
}