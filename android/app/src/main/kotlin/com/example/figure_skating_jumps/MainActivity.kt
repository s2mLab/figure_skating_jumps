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
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.example.figure_skating_jumps.event_channels.XSensDotConnectionStreamHandler
import com.example.figure_skating_jumps.xsens_dot_managers.XSensDotDeviceScanner
import com.example.figure_skating_jumps.xsens_dot_managers.XSensDotRecorder
import com.example.figure_skating_jumps.xsens_dot_managers.XsensDotDeviceCustomCallback


class MainActivity : FlutterActivity() {
    private var currentXSensDot: XsensDotDevice? = null
    private var XSensDotRecorder: XSensDotRecorder? = null
    private lateinit var XSensDotDeviceScanner: XSensDotDeviceScanner
    private lateinit var eventChannel: EventChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        XSensDotDeviceScanner = XSensDotDeviceScanner(this)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "xsens-dot-channel"
        ).setMethodCallHandler { call, result ->
            handleXsensDotCalls(call, result)
        }
        eventChannel = EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "xsens-dot-event-channel"
        )
        eventChannel.setStreamHandler(
            XSensDotConnectionStreamHandler
        )
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
            "getSDKVersion" -> getSDKVersion(result)
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
        XSensDotConnectionStreamHandler.sendEvent("The event stream works!")
        result.success(XsensDotSdk.getSdkVersion())
    }

    private fun startScan(result: MethodChannel.Result) {
        PermissionUtils.manageBluetoothRequirements(this)
        XSensDotDeviceScanner.startScan()
        result.success("Scan Started!")
    }

    private fun stopScan(result: MethodChannel.Result) {
        result.success(XSensDotDeviceScanner.stopScan().toString())
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
        XSensDotRecorder = XSensDotRecorder(context, currentXSensDot!!)

        SystemClock.sleep(30)
        XSensDotRecorder?.enableDataRecordingNotification()

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
        XSensDotRecorder = null
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
        XSensDotRecorder?.startRecording()

        Log.i("Android", "start")
        result.success(currentXSensDot?.name)
    }

    private fun stopRecording(result: MethodChannel.Result) {
        XSensDotRecorder?.stopRecording()

        Log.i("Android", "stop")
        result.success(currentXSensDot?.name)
    }

    private fun exportDataFile(result: MethodChannel.Result) {
        XSensDotRecorder?.getFileInfo()
        Log.i("Android", "File Info")
        result.success(currentXSensDot?.name)
    }
}
