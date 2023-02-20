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
        val isFineLocationGranted = isFineLocationPermissionGranted(activity)
        val isCoarseLocationGranted = isCoarseLocationGranted(activity)
        val isBackgroundLocationGranted = isBackgroundLocationGranted(activity)
        val isScanGranted = isBluetoothScanPermissionGranted(activity)
        val isConnectGranted = isBluetoothConnectPermissionGranted(activity)
        val isAdminGranted = isBluetoothAdminPermissionGranted(activity)
        val isBluetoothGranted = isBluetoothPermissionGranted(activity)
        if (!isBluetoothEnabled) {
            requestEnableBluetooth(activity)
        }

        /*if (!isPermissionGranted) requestLocationPermission(activity)
        if (!isScanGranted) requestBluetoothScanPermission(activity)
        if (!isConnectGranted) requestBluetoothConnectPermission(activity)*/

        Log.i("Android", "Bluetooth Adapter - ${isBluetoothAdapterEnabled(activity)}")
        Log.i("Android", "Bluetooth - ${isBluetoothPermissionGranted(activity)}")
        Log.i("Android", "Admin - ${isBluetoothAdminPermissionGranted(activity)}")
        Log.i("Android", "Fine - ${isFineLocationPermissionGranted(activity)}")
        Log.i("Android", "Coarse - ${isCoarseLocationGranted(activity)}")
        Log.i("Android", "Background - ${isBackgroundLocationGranted(activity)}")
        Log.i("Android", "Scan - ${isBluetoothScanPermissionGranted(activity)}")
        Log.i("Android", "Connect - ${isBluetoothConnectPermissionGranted(activity)}")

        var permissions = arrayOf<String>()
        if(!isBluetoothGranted) permissions = permissions.plus(Manifest.permission.BLUETOOTH)
        if (!isAdminGranted) permissions = permissions.plus(Manifest.permission.BLUETOOTH_ADMIN)
        if (!isFineLocationGranted) permissions =
            permissions.plus(Manifest.permission.ACCESS_FINE_LOCATION)
        if(!isCoarseLocationGranted) permissions =
            permissions.plus(Manifest.permission.ACCESS_COARSE_LOCATION)
        if(!isBackgroundLocationGranted) permissions =
            permissions.plus(Manifest.permission.ACCESS_BACKGROUND_LOCATION)
        if (!isScanGranted) permissions = permissions.plus(Manifest.permission.BLUETOOTH_SCAN)
        if (!isConnectGranted) permissions = permissions.plus(Manifest.permission.BLUETOOTH_CONNECT)

        requestRequiredBluetoothPermission(activity, permissions)

        val status = isBluetoothAdapterEnabled(activity)
                && isFineLocationPermissionGranted(activity)
                && isBluetoothAdminPermissionGranted(activity)
                && isBluetoothPermissionGranted(activity)
        Log.i("Android", "checkBluetoothAndPermission() - $status")
        return status
    }

    private fun isBluetoothAdapterEnabled(context: Context): Boolean {
        val bluetoothManager =
            context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val bluetoothAdapter = bluetoothManager.adapter
        if (bluetoothAdapter != null) return bluetoothAdapter.isEnabled
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

    private fun isBluetoothPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.BLUETOOTH) == PackageManager.PERMISSION_GRANTED
    }
    private fun isBluetoothAdminPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.BLUETOOTH_ADMIN) == PackageManager.PERMISSION_GRANTED
    }

    private fun isFineLocationPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
    }

    private fun isCoarseLocationGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED
    }

    private fun isBackgroundLocationGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.ACCESS_BACKGROUND_LOCATION) == PackageManager.PERMISSION_GRANTED
    }

    private fun isBluetoothConnectPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED
    }

    private fun isBluetoothScanPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestRequiredBluetoothPermission(
        activity: Activity,
        permissions: Array<String>,
        requestCode: Int = 42
    ) {
        if (permissions.isNotEmpty()) activity.requestPermissions(permissions, requestCode)
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