package com.example.figure_skating_jumps.x_sens_dot.callbacks

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanSettings
import android.content.Intent
import android.util.Log
import com.example.figure_skating_jumps.MainActivity
import com.example.figure_skating_jumps.channels.event_channels.XSensDotScanStreamHandler
import com.xsens.dot.android.sdk.interfaces.XsensDotDeviceCallback
import com.xsens.dot.android.sdk.interfaces.XsensDotScannerCallback
import com.xsens.dot.android.sdk.utils.XsensDotScanner

/**
 * A class that implements the [XsensDotScannerCallback] abstract class. This class allows to start,
 * stop and handle a XSens Dot bluetooth scan
 *
 * @param mainActivity The application MainActivity
 */
class XSensDotDeviceScanner(mainActivity: MainActivity) : XsensDotScannerCallback {
    private var mainActivity: MainActivity? = mainActivity
    private var mXsScanner: XsensDotScanner = XsensDotScanner(mainActivity, this)

    /**
     * Overrides the XSens Dot scanned callback. Sends the scanned device to the flutter project
     *
     * @param device The scanned XSens Dot
     * @param rssi The scanned device RSSI
     */
    override fun onXsensDotScanned(device: BluetoothDevice?, rssi: Int) {
        if (device?.address != null) {
                XSensDotScanStreamHandler.sendEvent(device)
        }
    }

    /**
     * Starts a XSens Dot bluetooth scan
     */
    fun startScan() {
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

    /**
     * Stops a XSens Dot bluetooth scan
     */
    fun stopScan() {
        mXsScanner.stopScan()
    }
}