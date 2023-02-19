package com.xsens.dot.android.example.utils

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Looper
import androidx.core.app.ActivityCompat


object Utils {

    val isMainThread: Boolean
        get() = Looper.myLooper() == Looper.getMainLooper()
    
    fun isBluetoothAdapterEnabled(context: Context): Boolean {
        val bluetoothManager =
            context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        if (bluetoothManager != null) {
            val bluetoothAdapter = bluetoothManager.adapter
            if (bluetoothAdapter != null) return bluetoothAdapter.isEnabled
        }
        return false
    }

    fun requestEnableBluetooth(activity: Activity, requestCode: Int) {
        val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
        if (ActivityCompat.checkSelfPermission(
                activity,
                Manifest.permission.BLUETOOTH_CONNECT
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            activity.startActivityForResult(intent, requestCode)

        }
    }

    fun isLocationPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
    }

    fun isBluetoothConnectPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED
    }

    fun isBluetoothScanPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_GRANTED
    }

    fun requestLocationPermission(activity: Activity, requestCode: Int) {
        activity.requestPermissions(arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), requestCode)
    }

    fun requestBluetoothConnectPermission(activity: Activity, requestCode: Int) {
        activity.requestPermissions(arrayOf(Manifest.permission.BLUETOOTH_CONNECT), requestCode)
    }

    fun requestBluetoothScanPermission(activity: Activity, requestCode: Int) {
        activity.requestPermissions(arrayOf(Manifest.permission.BLUETOOTH_SCAN), requestCode)
    }
}