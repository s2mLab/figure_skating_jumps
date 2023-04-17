//Inspired by the code given by the Movella Team
package com.example.figure_skating_jumps.permissions

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
import com.example.figure_skating_jumps.MainActivity
import com.example.figure_skating_jumps.R
import com.example.figure_skating_jumps.channels.event_channels.BluetoothPermissionStreamHandler


/**
 * A class that contains method to check and manage bluetooth permissions and requirements
 */
object PermissionUtils {
    private const val bluetoothEnableRequestCode = 1001
    private const val requiredBluetoothPermissionsRequestCode: Int = 1002

    /**
     * The method controls the bluetooth requirements flow.
     * It verifies that the bluetooth is enabled
     * and, if enabled, ask for the required runtime permissions
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

    /**
     * Handle the results of a Bluetooth Adapter Enable request
     *
     * @param requestCode The code used to identify the request
     * @param resultCode The code representing the user choice
     * @param activity The main activity of the application
     */
    fun handleBluetoothRequestResults(requestCode: Int, resultCode: Int, activity: MainActivity) {
        if (requestCode != bluetoothEnableRequestCode) return
        if (resultCode == RESULT_OK) {
            manageBluetoothPermissions(activity)
        } else {
            Log.i("Android", "Bluetooth Adapter - Bluetooth request denied")
            showRequiredDialog(activity, activity.getString(R.string.bluetooth_disabled_message))
        }
    }
    /**
     * Handle the results of a Bluetooth Permissions request
     *
     * @param requestCode The code used to identify the request
     * @param permissions An [Array] containing the requested permissions
     * @param grantResults An [IntArray] containing the result for each permissions
     * @param activity The main activity of the application
     */
    fun handlePermissionsRequestResults(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
        activity: Activity
    ) {
        if (requestCode != requiredBluetoothPermissionsRequestCode) return
        for ((i, perm) in permissions.withIndex()) {
            Log.i(
                "Android",
                "Result for $perm - Granted: ${grantResults[i] == PackageManager.PERMISSION_GRANTED}"
            )
        }
        val isAccepted = grantResults.all { it == PackageManager.PERMISSION_GRANTED }
        BluetoothPermissionStreamHandler.sendEvent(
            isAccepted
        )
        if(isAccepted) return

        Log.i("Android", "Permission request denied")
        if(shouldShowPermissionDialog(activity, permissions)) {
            showRequiredDialog(activity, buildPermissionMessage(activity, permissions))
        }
    }

    /**
     * The method controls the bluetooth permissions flow.
     * It verifies that the bluetooth required runtime permissions are granted
     * and, if not granted enabled, ask for the required runtime permissions
     *
     * @param activity The main activity of the application
     */
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

    /**
     * The method verifies if the bluetooth adapter is enabled
     *
     * @param context The current activity context
     *
     * @return A [Boolean] representing whether the bluetooth adapter is enabled or not
     */
    private fun isBluetoothAdapterEnabled(context: Context): Boolean {
        val bluetoothManager =
            context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val bluetoothAdapter = bluetoothManager.adapter
        if (bluetoothAdapter != null) return bluetoothAdapter.isEnabled
        return false
    }

    /**
     * The method request the user to enable the bluetooth adapter
     *
     * @param activity The main activity of the application
     * @param requestCode A code to identify the request
     */
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

    /**
     * The method verifies if the fine location permission is granted
     *
     * @param cactivity The main activity of the application
     *
     * @return A [Boolean] representing whether the fine location permission is granted or not
     */
    private fun isFineLocationPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
    }

    /**
     * The method verifies if the bluetooth connect permission is granted
     *
     * @param cactivity The main activity of the application
     *
     * @return A [Boolean] representing whether the bluetooth connect permission is granted or not
     */
    @RequiresApi(Build.VERSION_CODES.S)
    private fun isBluetoothConnectPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED
    }

    /**
     * The method verifies if the bluetooth scan permission is granted
     *
     * @param activity The main activity of the application
     *
     * @return A [Boolean] representing whether the bluetooth scan permission is granted or not
     */
    @RequiresApi(Build.VERSION_CODES.S)
    private fun isBluetoothScanPermissionGranted(activity: Activity): Boolean {
        return activity.checkSelfPermission(permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_GRANTED
    }

    /**
     * The method request the user to granted the bluetooth permissions
     *
     * @param activity The main activity of the application
     * @param permissions An [Array] containing the permissions to grant
     * @param requestCode A code to identify the request
     */
    private fun requestRequiredBluetoothPermissions(
        activity: Activity,
        permissions: Array<String>,
        requestCode: Int = requiredBluetoothPermissionsRequestCode
    ) {

        if (permissions.isEmpty()) {
            BluetoothPermissionStreamHandler.sendEvent(
                true
            )
            return
        }

        if (shouldShowPermissionDialog(activity, permissions)) {
            showRequiredDialog(activity, buildPermissionMessage(activity, permissions))
            return
        }

        ActivityCompat.requestPermissions(
            activity,
            permissions,
            requestCode
        )
    }

    /**
     * The method check if a permission dialog should be displayed
     *
     * @param activity The main activity of the application
     * @param permissions An [Array] containing the permissions to grant
     *
     * @return A [Boolean] representing whether a
     * permission rationale dialog should be displayed or not
     */
    private fun shouldShowPermissionDialog(
        activity: Activity,
        permissions: Array<out String>
    ): Boolean {
        val shouldShowLocationDialog = shouldShowLocationDialog(activity, permissions)
        val shouldShowDeviceDialog = shouldShowDeviceDialog(activity, permissions)
        return shouldShowLocationDialog || shouldShowDeviceDialog
    }

    /**
     * The method check if a permission dialog linked to location permission should be displayed
     *
     * @param activity The main activity of the application
     * @param permissions An [Array] containing the permissions to grant
     *
     * @return A [Boolean] representing whether a location
     * permission rationale dialog should be displayed or not
     */
    private fun shouldShowLocationDialog(
        activity: Activity,
        permissions: Array<out String>
    ): Boolean {
        return permissions.contains(permission.ACCESS_FINE_LOCATION)
                && activity.shouldShowRequestPermissionRationale(permission.ACCESS_FINE_LOCATION)
    }

    /**
     * The method check if a bluetooth permission dialog should be displayed
     *
     * @param activity The main activity of the application
     * @param permissions An [Array] containing the permissions to grant
     *
     * @return A [Boolean] representing whether a bluetooth
     * permission rationale dialog should be displayed or not
     */
    private fun shouldShowDeviceDialog(
        activity: Activity,
        permissions: Array<out String>
    ): Boolean {
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.R) {
            return (permissions.contains(permission.BLUETOOTH_SCAN)
                    && activity.shouldShowRequestPermissionRationale(permission.BLUETOOTH_SCAN))
                    || (permissions.contains(permission.BLUETOOTH_CONNECT)
                    && activity.shouldShowRequestPermissionRationale(permission.BLUETOOTH_CONNECT))
        }
        return false
    }

    /**
     * The method build a message to inform the user which permissions must be granted permissions
     * to use the bluetooth functionalities of the app
     *
     * @param activity The main activity of the application
     * @param permissions An [Array] containing the permissions to grant
     */
    private fun buildPermissionMessage(activity: Activity, permissions: Array<out String>): String {
        var message = ""

        if (shouldShowLocationDialog(activity, permissions))
            message += activity.getString(R.string.location_permission_message)
        if (shouldShowDeviceDialog(activity, permissions))
            message += "\n" + activity.getString(R.string.devices_permission_message)

        return message
    }

    /**
     * The method display a dialog to inform the user he must grant permissions to use the bluetooth
     * functionalities of the app
     *
     * @param activity The main activity of the application
     * @param message The explanation message for the user
     */
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