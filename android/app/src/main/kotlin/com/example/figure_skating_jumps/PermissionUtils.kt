//Inspired by the code given by the Movella Team
package com.example.figure_skating_jumps

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Looper
import android.util.Log
import androidx.core.app.ActivityCompat


object PermissionUtils {
    private const val BluetoothRequestCode = 1001
    private const val LocationRequestCode = 1002
    private const val BluetoothScanRequestCode = 1003
    private const val BluetoothConnectRequestCode = 1004

    val isMainThread: Boolean
        get() = Looper.myLooper() == Looper.getMainLooper()

    fun checkBluetoothAndPermission(activity: MainActivity): Boolean {
        val isBluetoothEnabled = isBluetoothAdapterEnabled(activity)
        val isPermissionGranted = isLocationPermissionGranted(activity)
        val isScanGranted = isBluetoothScanPermissionGranted(activity)
        val isConnectGranted = isBluetoothConnectPermissionGranted(activity)
        if (!isBluetoothEnabled) {
            requestEnableBluetooth(activity)
        }
        if (!isPermissionGranted) requestLocationPermission(activity)
        if (!isScanGranted) requestBluetoothScanPermission(activity)
        if (!isConnectGranted) requestBluetoothConnectPermission(activity)

        val status = isBluetoothEnabled && isPermissionGranted
        Log.i("Android", "checkBluetoothAndPermission() - $status")
        return status
    }

    private fun isBluetoothAdapterEnabled(context: Context): Boolean {
        val bluetoothManager =
            context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        if (bluetoothManager != null) {
            val bluetoothAdapter = bluetoothManager.adapter
            if (bluetoothAdapter != null) return bluetoothAdapter.isEnabled
        }
        return false
    }

    private fun requestEnableBluetooth(
        activity: Activity,
        requestCode: Int = BluetoothRequestCode
    ) {
        val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
        if (ActivityCompat.checkSelfPermission(
                activity,
                Manifest.permission.BLUETOOTH_CONNECT
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            activity.startActivityForResult(intent, requestCode)

        }
    }

    private fun isLocationPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
    }

    private fun isBluetoothConnectPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED
    }

    private fun isBluetoothScanPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestLocationPermission(
        activity: Activity,
        requestCode: Int = LocationRequestCode
    ) {
        activity.requestPermissions(arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), requestCode)
    }

    private fun requestBluetoothConnectPermission(
        activity: Activity,
        requestCode: Int = BluetoothConnectRequestCode
    ) {
        activity.requestPermissions(arrayOf(Manifest.permission.BLUETOOTH_CONNECT), requestCode)
    }

    private fun requestBluetoothScanPermission(
        activity: Activity,
        requestCode: Int = BluetoothScanRequestCode
    ) {
        activity.requestPermissions(arrayOf(Manifest.permission.BLUETOOTH_SCAN), requestCode)
    }
}