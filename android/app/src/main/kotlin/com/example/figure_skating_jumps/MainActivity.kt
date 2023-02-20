package com.example.figure_skating_jumps

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.Context
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import androidx.annotation.NonNull
import com.example.figure_skating_jumps.PermissionUtils.checkBluetoothAndPermission
import com.xsens.dot.android.sdk.XsensDotSdk
import com.xsens.dot.android.sdk.models.XsensDotDevice
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var currentXSensDot: XsensDotDevice? = null
    private lateinit var deviceScanner: DeviceScanner

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        deviceScanner = DeviceScanner(this)

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
            "getSDKVersion" -> getSDKVersion(result)
            "startScan" -> startScan(result)
            "stopScan" -> stopScan(result)
            "connectXSensDot" -> connectXSensDot(call, result)
            "disconnectXSensDot" -> disconnectXSensDot(result)
            "startMeasuring" -> startMeasuring(result)
            "stopMeasuring" -> stopMeasuring(result)
            else -> result.notImplemented()
        }
    }

    private fun getSDKVersion(result: MethodChannel.Result) {
       result.success(XsensDotSdk.getSdkVersion())
    }

    private fun startScan(result: MethodChannel.Result) {
        checkBluetoothAndPermission(this)
        deviceScanner.startScan()
        result.success("Scan Started!")
    }

    private fun stopScan(result: MethodChannel.Result) {
        result.success(deviceScanner.stopScan().toString())
    }

    private fun connectXSensDot(call: MethodCall, result: MethodChannel.Result) {
        checkBluetoothAndPermission(this)
        val xsensDotDeviceCB = XsensDotDeviceCB()

        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val mBluetoothAdapter = bluetoothManager.adapter
        val device: BluetoothDevice = mBluetoothAdapter.getRemoteDevice(call.argument<String>("address"))

        currentXSensDot = XsensDotDevice(this@MainActivity, device, xsensDotDeviceCB)

        currentXSensDot?.connect()

        result.success(call.argument<String>("address"))
    }

    private fun disconnectXSensDot(result: MethodChannel.Result) {
        try {
            currentXSensDot?.disconnect()
            result.success("Successfully disconnected device: ${currentXSensDot?.address}")
        } catch (e : Error) {
            val disconnectErrorCode = "42"
            result.error(disconnectErrorCode, e.message, e.stackTrace )
        }
    }

    private fun startMeasuring(result: MethodChannel.Result) {
        currentXSensDot?.startMeasuring()
        Log.i("Android", "start")
        result.success(currentXSensDot?.name)
    }

    private fun stopMeasuring(result: MethodChannel.Result) {
        currentXSensDot?.stopMeasuring()
        Log.i("Android", "stop")
        result.success(currentXSensDot?.name)
    }
}
