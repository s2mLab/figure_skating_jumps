//Inspired by the code given by the Movella Team
package com.example.figure_skating_jumps

import android.Manifest
import android.app.Activity
import android.app.Activity.RESULT_OK
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat


object PermissionUtils {
    private const val bluetoothEnableRequestCode = 1001
    private const val requiredBluetoothPermissionsRequestCode: Int = 1002

    /**
     * The method controls the bluetooth requirements flow. It verify that the bluetooth is enabled
     * and, if enabled, ask for the required runtime permissions.
     *
     * @param activity The main activity of the application
     */
    fun manageBluetoothRequirements(activity: MainActivity) {
        val isBluetoothEnabled = isBluetoothAdapterEnabled(activity)
        if (!isBluetoothEnabled) {
            requestEnableBluetooth(activity)
        }
        else {
            manageBluetoothPermissions(activity)
        }
        Log.i("Android", "Bluetooth Adapter - ${isBluetoothAdapterEnabled(activity)}")
    }

    fun handleBluetoothRequestResults(requestCode: Int, resultCode: Int, activity: MainActivity){
        if(requestCode == bluetoothEnableRequestCode && resultCode == RESULT_OK){
            manageBluetoothPermissions(activity)
        }
        else {
            Log.i("Android", "Bluetooth Adapter - Bluetooth request denied")
            //TODO show message to user
        }
    }

    fun handlePermissionsRequestResults(requestCode: Int,
                                        permissions: Array<out String>,
                                        grantResults: IntArray){
        if(requestCode == requiredBluetoothPermissionsRequestCode) {
            Log.i("Android", "Hey I was asked permissions!")
            Log.i("Android", "Here are the results")
            for((i, perm) in permissions.withIndex()){
                Log.i("Android", "Result for $perm - Granted: ${grantResults[i] == PackageManager.PERMISSION_GRANTED}")
            }
        }
    }

    private fun manageBluetoothPermissions(activity: MainActivity) {
        val isFineLocationGranted = isFineLocationPermissionGranted(activity)
        val isScanGranted =
            Build.VERSION.SDK_INT > Build.VERSION_CODES.R
            && isBluetoothScanPermissionGranted(activity)
        val isConnectGranted =
            Build.VERSION.SDK_INT > Build.VERSION_CODES.R
            && isBluetoothConnectPermissionGranted(activity)

        var permissions = arrayOf<String>()
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.R) {
            if (!isScanGranted) permissions = permissions.plus(Manifest.permission.BLUETOOTH_SCAN)
            if (!isConnectGranted) permissions =
                permissions.plus(Manifest.permission.BLUETOOTH_CONNECT)
        }
        if (!isFineLocationGranted) permissions =
            permissions.plus(Manifest.permission.ACCESS_FINE_LOCATION)

        requestRequiredBluetoothPermissions(activity, permissions)
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
        requestCode: Int = bluetoothEnableRequestCode
    ) {
        val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
        try {
            activity.startActivityForResult(intent, requestCode)
        } catch (e: SecurityException) {
            Log.e("Android", "Enable bluetooth request denied - ${e.message}")
        }
    }

    private fun isFineLocationPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
    }

    @RequiresApi(Build.VERSION_CODES.S)
    private fun isBluetoothConnectPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED
    }

    @RequiresApi(Build.VERSION_CODES.S)
    private fun isBluetoothScanPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(Manifest.permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestRequiredBluetoothPermissions(
        activity: Activity,
        permissions: Array<String>,
        requestCode: Int = requiredBluetoothPermissionsRequestCode
    ) {
        for (perm in permissions) {
            Log.i("Android", "Permission asked - $perm")
            Log.i(
                "Android",
                "Need for special UI - $perm: ${activity.shouldShowRequestPermissionRationale(perm)}"
            )
        }
        Log.i("Android", "Total permissions asked - ${permissions.size}")

        if (permissions.isNotEmpty()) ActivityCompat.requestPermissions(
            activity,
            permissions,
            requestCode
        )
    }
}