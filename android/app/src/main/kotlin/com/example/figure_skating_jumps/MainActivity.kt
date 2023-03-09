package com.example.figure_skating_jumps

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.os.SystemClock
import android.util.Log
import androidx.annotation.NonNull
import com.xsens.dot.android.sdk.XsensDotSdk
import com.xsens.dot.android.sdk.models.XsensDotDevice
import com.xsens.dot.android.sdk.models.XsensDotPayload
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private var currentXSensDot: XsensDotDevice? = null
    private var recordingCallback: RecordingCallback? = null
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        PermissionUtils.handleBluetoothRequestResults(requestCode, resultCode, this)
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        PermissionUtils.handlePermissionsRequestResults(
            requestCode,
            permissions,
            grantResults,
            this
        )
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    //Had the supported methods here (the when acts like a switch statement)
    private fun handleXsensDotCalls(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getSDKVersion" -> exportDataFile(result)
            "startScan" -> startScan(result)
            "stopScan" -> stopScan(result)
            "connectXSensDot" -> connectXSensDot(call, result)
            "setRate" -> setRate(call, result)
            "disconnectXSensDot" -> disconnectXSensDot(result)
            //TODO add change measuring for recording
            "startMeasuring" -> startRecording(result)
            "stopMeasuring" -> stopRecording(result)
            else -> result.notImplemented()
        }
    }

    private fun getSDKVersion(result: MethodChannel.Result) {
        result.success(XsensDotSdk.getSdkVersion())
    }

    private fun startScan(result: MethodChannel.Result) {
        PermissionUtils.manageBluetoothRequirements(this)
        deviceScanner.startScan()
        result.success("Scan Started!")
    }

    private fun stopScan(result: MethodChannel.Result) {
        result.success(deviceScanner.stopScan().toString())
    }

    private fun connectXSensDot(call: MethodCall, result: MethodChannel.Result) {
        PermissionUtils.manageBluetoothRequirements(this)
        val xsensDotDeviceCustomCallback = XsensDotDeviceCustomCallback()

        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val mBluetoothAdapter = bluetoothManager.adapter
        val device: BluetoothDevice =
            mBluetoothAdapter.getRemoteDevice(call.argument<String>("address"))

        currentXSensDot = XsensDotDevice(context, device, xsensDotDeviceCustomCallback)

        currentXSensDot?.connect()
        recordingCallback = RecordingCallback(context, currentXSensDot!!)

        SystemClock.sleep(30)
        recordingCallback?.enableDataRecordingNotification()

        result.success(call.argument<String>("address"))
    }

    private fun setRate(call: MethodCall, result: MethodChannel.Result) {
        val rate: Int?  = call.argument<Int>("rate")
        if (rate != null) {
            currentXSensDot?.setOutputRate(rate)
            return
        }
        result.error("0","Rate not set", null)
    }

    private fun disconnectXSensDot(result: MethodChannel.Result) {
        currentXSensDot?.disconnect()
        recordingCallback = null
        result.success("Successfully disconnected device: ${currentXSensDot?.address}")
    }

    private fun startMeasuring(result: MethodChannel.Result) {
        if (currentXSensDot == null) {
            return
        }
        currentXSensDot?.startMeasuring()

        Log.i("Android", "start")
        result.success(currentXSensDot?.name)
    }

    private fun stopMeasuring(result: MethodChannel.Result) {
        Log.i("Android", "stop")
        currentXSensDot?.stopMeasuring()

        result.success(currentXSensDot?.name)
    }

    private fun startRecording(result: MethodChannel.Result){
        if (currentXSensDot == null) {
            return
        }
        recordingCallback?.startRecording()

        Log.i("Android", "start")
        result.success(currentXSensDot?.name)
    }

    private fun stopRecording(result: MethodChannel.Result) {
        recordingCallback?.stopRecording()

        Log.i("Android", "stop")
        result.success(currentXSensDot?.name)
    }

    private fun exportDataFile(result: MethodChannel.Result) {
        recordingCallback?.getFileInfo()
        Log.i("Android", "File Info")
        result.success(currentXSensDot?.name)
    }
}
