//Inspired by the code given by the Movella Team
package com.example.figure_skating_jumps

import android.Manifest.permission
import android.app.Activity
import android.app.Activity.RESULT_OK
import android.app.AlertDialog
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
     * The method controls the bluetooth requirements flow. It verifies that the bluetooth is enabled
     * and, if enabled, ask for the required runtime permissions.
     *
     * @param activity The main activity of the application
     */
    fun manageBluetoothRequirements(activity: MainActivity) {
        val isBluetoothEnabled = isBluetoothAdapterEnabled(activity)
        Log.i("Android", "Bluetooth Adapter - $isBluetoothEnabled")
        Log.i("Android", "Bluetooth Adapter - ${isBluetoothAdapterEnabled(activity)}")
        if (!isBluetoothEnabled) {
            requestEnableBluetooth(activity)
        } else {
            manageBluetoothPermissions(activity)
        }
        Log.i("Android", "Bluetooth Adapter - ${isBluetoothAdapterEnabled(activity)}")
    }

    fun handleBluetoothRequestResults(requestCode: Int, resultCode: Int, activity: MainActivity) {
        if(requestCode != bluetoothEnableRequestCode) return
        if (resultCode == RESULT_OK) {
            manageBluetoothPermissions(activity)
        } else {
            Log.i("Android", "Bluetooth Adapter - Bluetooth request denied")
            showRequiredDialog(activity, activity.getString(R.string.bluetooth_disabled_message))
        }
    }

    fun handlePermissionsRequestResults(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
        activity: Activity
    ) {
        if (requestCode == requiredBluetoothPermissionsRequestCode) {
            for ((i, perm) in permissions.withIndex()) {
                Log.i(
                    "Android",
                    "Result for $perm - Granted: ${grantResults[i] == PackageManager.PERMISSION_GRANTED}"
                )
            }
            if(grantResults.contains(PackageManager.PERMISSION_DENIED)){
                if(shouldShowPermissionDialog(activity, permissions)){
                    showRequiredDialog(activity, buildPermissionMessage(activity, permissions))
                    return
                }
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
        if (!isFineLocationGranted) permissions =
            permissions.plus(permission.ACCESS_FINE_LOCATION)

        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.R) {
            if (!isScanGranted) permissions = permissions.plus(permission.BLUETOOTH_SCAN)
            if (!isConnectGranted) permissions =
                permissions.plus(permission.BLUETOOTH_CONNECT)
        }

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
        return activity.checkSelfPermission(permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
    }

    @RequiresApi(Build.VERSION_CODES.S)
    private fun isBluetoothConnectPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED
    }

    @RequiresApi(Build.VERSION_CODES.S)
    private fun isBluetoothScanPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestRequiredBluetoothPermissions(
        activity: Activity,
        permissions: Array<String>,
        requestCode: Int = requiredBluetoothPermissionsRequestCode
    ) {
        if(permissions.isEmpty()) return

        if(shouldShowPermissionDialog(activity, permissions)){
            showRequiredDialog(activity, buildPermissionMessage(activity, permissions))
            return
        }

        ActivityCompat.requestPermissions(
            activity,
            permissions,
            requestCode
        )
    }

    private fun shouldShowPermissionDialog(activity: Activity, permissions: Array<out String>): Boolean {
        val shouldShowLocationDialog = shouldShowLocationDialog(activity, permissions)
        val shouldShowDeviceDialog = shouldShowDeviceDialog(activity, permissions)
        return shouldShowLocationDialog || shouldShowDeviceDialog
    }

    private fun shouldShowLocationDialog(activity: Activity, permissions: Array<out String>): Boolean {
        return permissions.contains(permission.ACCESS_FINE_LOCATION)
                && activity.shouldShowRequestPermissionRationale(permission.ACCESS_FINE_LOCATION)
    }

    private fun shouldShowDeviceDialog(activity: Activity, permissions: Array<out String>): Boolean {
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.R) {
            return (permissions.contains(permission.BLUETOOTH_SCAN)
                    && activity.shouldShowRequestPermissionRationale(permission.BLUETOOTH_SCAN))
                    || (permissions.contains(permission.BLUETOOTH_CONNECT)
                    && activity.shouldShowRequestPermissionRationale(permission.BLUETOOTH_CONNECT))
        }
        return false
    }

    private fun buildPermissionMessage(activity: Activity, permissions: Array<out String>): String {
        var message = ""

        if (shouldShowLocationDialog(activity, permissions))
            message += activity.getString(R.string.location_permission_message)
        if (shouldShowDeviceDialog(activity, permissions))
            message += "\n" + activity.getString(R.string.devices_permission_message)

        return message
    }

    private fun showRequiredDialog(activity: Activity, message: String) {
        val builder = AlertDialog.Builder(activity)
        builder.apply {
            setTitle(R.string.bluetooth_required_dialog_title)
            setMessage(message)
            setNeutralButton("Ok") { dialog, _ ->
                dialog.dismiss()
            }
        }
        builder.create()
        builder.show()
    }
}