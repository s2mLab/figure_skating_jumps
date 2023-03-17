package com.example.figure_skating_jumps

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.os.SystemClock
import android.util.Log
import androidx.annotation.NonNull
import com.example.figure_skating_jumps.channels.enums.EventChannelNames
import com.example.figure_skating_jumps.channels.event_channels.*
import com.example.figure_skating_jumps.channels.enums.MethodChannelNames
import com.xsens.dot.android.sdk.XsensDotSdk
import com.xsens.dot.android.sdk.models.XsensDotDevice
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.example.figure_skating_jumps.permissions.PermissionUtils
import com.example.figure_skating_jumps.x_sens_dot.callbacks.XSensDotDeviceScanner
import com.example.figure_skating_jumps.x_sens_dot.callbacks.XSensDotRecorder
import com.example.figure_skating_jumps.x_sens_dot.callbacks.XSensDotDeviceCustomCallback
import com.example.figure_skating_jumps.x_sens_dot.utils.XSensFileInfoSerializer
import com.xsens.dot.android.sdk.models.XsensDotRecordingFileInfo
import io.flutter.plugin.common.BinaryMessenger


class MainActivity : FlutterActivity() {
    private var currentXSensDot: XsensDotDevice? = null
    private var xSensDotRecorder: XSensDotRecorder? = null
    private lateinit var xSensDotDeviceScanner: XSensDotDeviceScanner

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        xSensDotDeviceScanner = XSensDotDeviceScanner(this)
        setUpChannels(flutterEngine.dartExecutor.binaryMessenger)
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

    private fun setUpChannels(messenger: BinaryMessenger){
        MethodChannel(
            messenger,
            MethodChannelNames.XSensDotChannel.channelName
        ).setMethodCallHandler { call, result ->
            handleXsensDotCalls(call, result)
        }

        MethodChannel(
            messenger,
            MethodChannelNames.BluetoothChannel.channelName
        ).setMethodCallHandler { call, result ->
            handleBluetoothPermissionsCalls(call, result)
        }

        MethodChannel(
            messenger,
            MethodChannelNames.RecordingChannel.channelName
        ).setMethodCallHandler { call, result ->
            handleRecordingCalls(call, result)
        }

        EventChannel(
            messenger,
            EventChannelNames.BluetoothChannel.channelName
        ).setStreamHandler(
            BluetoothPermissionStreamHandler
        )

        EventChannel(
            messenger,
            EventChannelNames.ConnectionChannel.channelName
        ).setStreamHandler(
            XSensDotConnectionStreamHandler
        )

        EventChannel(
            messenger,
            EventChannelNames.FileExportChannel.channelName
        ).setStreamHandler(
            XSensDotFileExportStreamHandler
        )

        EventChannel(
            messenger,
            EventChannelNames.MeasuringChannel.channelName
        ).setStreamHandler(
            XSensDotMeasuringStreamHandler
        )

        EventChannel(
            messenger,
            EventChannelNames.RecordingChannel.channelName
        ).setStreamHandler(
            XSensDotRecordingStreamHandler
        )

        EventChannel(
            messenger,
            EventChannelNames.ScanChannel.channelName
        ).setStreamHandler(
            XSensDotScanStreamHandler
        )
    }

    private fun handleBluetoothPermissionsCalls(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            else -> result.notImplemented()
        }
    }

    private fun handleRecordingCalls(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "enableRecordingNotification" -> enableRecordingNotification(result)
            "startRecording" -> startRecording(result)
            "stopRecording" -> stopRecording(result)
            "getFileInfo" -> getFileInfo(result)
            "extractFile" -> extractFile(call, result)
            else -> result.notImplemented()
        }
    }
    private fun handleXsensDotCalls(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getSDKVersion" -> getSDKVersion(result)
            "startScan" -> startScan(result)
            "stopScan" -> stopScan(result)
            "connectXSensDot" -> connectXSensDot(call, result)
            "setRate" -> setRate(call, result)
            "disconnectXSensDot" -> disconnectXSensDot(result)
            "startMeasuring" -> startMeasuring(result)
            "stopMeasuring" -> stopMeasuring(result)
            else -> result.notImplemented()
        }
    }

    //TODO unify result.success and result.error
    private fun getSDKVersion(result: MethodChannel.Result) {
        XSensDotConnectionStreamHandler.sendEvent(1)
        result.success(XsensDotSdk.getSdkVersion())
    }

    private fun startScan(result: MethodChannel.Result) {
        PermissionUtils.manageBluetoothRequirements(this)
        xSensDotDeviceScanner.startScan()
        result.success("Scan Started")
    }

    private fun stopScan(result: MethodChannel.Result) {
        xSensDotDeviceScanner.stopScan()
        result.success("Scan Stopped")
    }

    private fun connectXSensDot(call: MethodCall, result: MethodChannel.Result) {
        PermissionUtils.manageBluetoothRequirements(this)
        val xsensDotDeviceCustomCallback = XSensDotDeviceCustomCallback()

        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val mBluetoothAdapter = bluetoothManager.adapter
        val device: BluetoothDevice =
            mBluetoothAdapter.getRemoteDevice(call.argument<String>("address"))

        currentXSensDot = XsensDotDevice(context, device, xsensDotDeviceCustomCallback)

        currentXSensDot?.connect()
        xSensDotRecorder = XSensDotRecorder(context, currentXSensDot!!)

        //TODO remonter un event pour enable après le start?
        SystemClock.sleep(30)
        xSensDotRecorder?.enableDataRecordingNotification()

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
        xSensDotRecorder = null
        result.success("Successfully disconnected device: ${currentXSensDot?.address}")
    }

    private fun startMeasuring(result: MethodChannel.Result) {
        if (currentXSensDot == null) {
            result.error("1", "Not connected to device", null);
            return
        }
        currentXSensDot?.startMeasuring()

        Log.i("Android", "start")
        result.success("Measured Started")
    }

    private fun stopMeasuring(result: MethodChannel.Result) {
        Log.i("Android", "stop")
        currentXSensDot?.stopMeasuring()
        result.success("Measured Stopped")
    }

    private fun enableRecordingNotification(result: MethodChannel.Result) {
        xSensDotRecorder?.enableDataRecordingNotification()
        result.success(currentXSensDot?.name)
    }

    private fun startRecording(result: MethodChannel.Result){
        xSensDotRecorder?.startRecording()

        Log.i("Android", "start")
        result.success(currentXSensDot?.name)
    }

    private fun stopRecording(result: MethodChannel.Result) {
        xSensDotRecorder?.stopRecording()

        Log.i("Android", "stop")
        result.success(currentXSensDot?.name)
    }

    private fun getFileInfo(result: MethodChannel.Result) {
        xSensDotRecorder?.getFileInfo()
        result.success(currentXSensDot?.name)
    }

    private fun extractFile(call: MethodCall, result: MethodChannel.Result) {
        val file: String?  = call.argument<String>("fileInfo")

        if (file == null) {
            result.error("0","File string not set", null)
            return
        }

        val fileInfo: XsensDotRecordingFileInfo? = XSensFileInfoSerializer.deserialize(file)

        if (fileInfo == null) {
            result.error("0","File info not set", null)
            return
        }

        xSensDotRecorder?.extractFile(fileInfo)

        result.success(currentXSensDot?.name)
    }
}
