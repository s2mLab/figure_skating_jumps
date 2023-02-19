package com.example.figure_skating_jumps

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.xsens.dot.android.example.utils.Utils.isBluetoothAdapterEnabled
import com.xsens.dot.android.example.utils.Utils.isBluetoothConnectPermissionGranted
import com.xsens.dot.android.example.utils.Utils.isBluetoothScanPermissionGranted
import com.xsens.dot.android.example.utils.Utils.isLocationPermissionGranted
import com.xsens.dot.android.example.utils.Utils.requestBluetoothConnectPermission
import com.xsens.dot.android.example.utils.Utils.requestBluetoothScanPermission
import com.xsens.dot.android.example.utils.Utils.requestEnableBluetooth
import com.xsens.dot.android.example.utils.Utils.requestLocationPermission
import com.xsens.dot.android.sdk.XsensDotSdk
import com.xsens.dot.android.sdk.models.XsensDotDevice
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    var currentXsensDot: XsensDotDevice? = null
    var deviceScanner = DeviceScanner(this)


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "xsens-dot-channel"
        ).setMethodCallHandler { call, result ->
            handleXsensDotCalls(call, result)
        }
    }

    //Had the supported methods here (the when acts like a switch statement)
    private fun handleXsensDotCalls(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getSDKVersion" -> getSDKVersion(call, result)
            "getCloseXsensDot" -> getCloseXsensDot(call, result)
            "connectXsensDot" -> connectXsensDot(call, result)
            "startMeasuring" -> startMeasuring(call, result)
            "stopMeasuring" -> stopMeasuring(call, result)
            else -> result.notImplemented()
        }
    }

    private fun getSDKVersion(call: MethodCall, result: MethodChannel.Result) {
       result.success(XsensDotSdk.getSdkVersion())
    }

    private fun getCloseXsensDot(call: MethodCall, result: MethodChannel.Result) {
        checkBluetoothAndPermission()
        result.success(deviceScanner.getDevices())
    }

    private fun connectXsensDot(call: MethodCall, result: MethodChannel.Result) {
        checkBluetoothAndPermission()
        val xsensDotDeviceCB = XsensDotDeviceCB()

        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val mBluetoothAdapter = bluetoothManager.adapter
        val device: BluetoothDevice = mBluetoothAdapter.getRemoteDevice(call.argument<String>("address"))

        currentXsensDot = XsensDotDevice(this@MainActivity, device, xsensDotDeviceCB)

        currentXsensDot?.connect()

        result.success(call.argument<String>("address"))
    }

    private fun startMeasuring(call: MethodCall, result: MethodChannel.Result) {
        currentXsensDot?.startMeasuring()
        Log.i("Android", "start")
        result.success(currentXsensDot?.name)
    }

    private fun stopMeasuring(call: MethodCall, result: MethodChannel.Result) {
        currentXsensDot?.stopMeasuring()
        Log.i("Android", "stop")
        result.success(currentXsensDot?.name)
    }

    private fun checkBluetoothAndPermission(): Boolean {
        val isBluetoothEnabled = isBluetoothAdapterEnabled(this)
        val isPermissionGranted = isLocationPermissionGranted(this)
        val isScanGranted = isBluetoothScanPermissionGranted(this)
        val isConnectGranted = isBluetoothConnectPermissionGranted(this)
        if (!isBluetoothEnabled) {
            requestEnableBluetooth(this, 1001)
        }
        if (!isPermissionGranted) requestLocationPermission(
            this,
            1002
        )
        if (!isScanGranted) requestBluetoothScanPermission(
            this,
            1003
        )
        if (!isConnectGranted) requestBluetoothConnectPermission(
            this,
            1004
        )

        val status = isBluetoothEnabled && isPermissionGranted
        Log.i("Android", "checkBluetoothAndPermission() - $status")
        return status
    }
}
