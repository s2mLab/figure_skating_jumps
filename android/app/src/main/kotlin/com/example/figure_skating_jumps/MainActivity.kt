package com.example.figure_skating_jumps

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.os.SystemClock
import androidx.annotation.NonNull
import com.example.figure_skating_jumps.channels.enums.EventChannelParameters
import com.example.figure_skating_jumps.channels.enums.MethodChannelNames
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
import com.example.figure_skating_jumps.x_sens_dot.callbacks.XSensDotExporter
import com.example.figure_skating_jumps.x_sens_dot.enums.ErrorCodes
import com.example.figure_skating_jumps.x_sens_dot.utils.XSensFileInfoSerializer
import com.xsens.dot.android.sdk.models.XsensDotPayload
import com.xsens.dot.android.sdk.models.XsensDotRecordingFileInfo
import io.flutter.plugin.common.BinaryMessenger


class MainActivity : FlutterActivity() {
    private var currentXSensDot: XsensDotDevice? = null
    private var xSensDotRecorder: XSensDotRecorder? = null
    private var xSensDotExporter: XSensDotExporter? = null
    private lateinit var xSensDotDeviceScanner: XSensDotDeviceScanner
    private val sleepingTimeMs: Long = 30

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

    private fun setUpChannels(messenger: BinaryMessenger) {
        MethodChannel(
            messenger,
            MethodChannelNames.BluetoothChannel.channelName
        ).setMethodCallHandler { call, result -> handleBluetoothPermissionsCalls(call, result) }
        MethodChannel(
            messenger,
            MethodChannelNames.RecordingChannel.channelName
        ).setMethodCallHandler { call, result -> handleRecordingCalls(call, result) }
        MethodChannel(
            messenger,
            MethodChannelNames.MeasuringChannel.channelName
        ).setMethodCallHandler { call, result -> handleMeasuringCalls(call, result) }
        MethodChannel(
            messenger,
            MethodChannelNames.ConnectionChannel.channelName
        ).setMethodCallHandler { call, result -> handleConnectionCalls(call, result) }
        MethodChannel(
            messenger,
            MethodChannelNames.ScanChannel.channelName
        ).setMethodCallHandler { call, result -> handleScanCalls(call, result) }

        for (eventChannelParam in EventChannelParameters.values()) {
            EventChannel(messenger, eventChannelParam.channelName).setStreamHandler(
                eventChannelParam.streamHandler
            )
        }
    }

    private fun handleBluetoothPermissionsCalls(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "managePermissions" -> PermissionUtils.manageBluetoothRequirements(this)
            else -> result.notImplemented()
        }
    }

    private fun handleRecordingCalls(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "enableRecordingNotification" -> enableRecordingNotification(result)
            "startRecording" -> startRecording(result)
            "stopRecording" -> stopRecording(result)
            "setRate" -> setRate(call, result)
            "getFlashInfo" -> getFlashInfo(call, result)
            "getFileInfo" -> getFileInfo(result)
            "extractFile" -> extractFile(call, result)
            "prepareExtract" -> prepareExtract(result)
            "prepareRecording" -> prepareRecording(result)
            "eraseMemory" -> eraseMemory(result)
            else -> result.notImplemented()
        }
    }

    private fun handleMeasuringCalls(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startMeasuring" -> startMeasuring(result)
            "stopMeasuring" -> stopMeasuring(result)
            "setRate" -> setRate(call, result)
            else -> result.notImplemented()
        }
    }

    private fun handleConnectionCalls(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "connectXSensDot" -> connectXSensDot(call, result)
            "disconnectXSensDot" -> disconnectXSensDot(result)
            else -> result.notImplemented()
        }
    }

    private fun handleScanCalls(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startScan" -> startScan(result)
            "stopScan" -> stopScan(result)
            else -> result.notImplemented()
        }
    }

    private fun startScan(result: MethodChannel.Result) {
        xSensDotDeviceScanner.startScan()
        result.success(null)
    }

    private fun stopScan(result: MethodChannel.Result) {
        xSensDotDeviceScanner.stopScan()
        result.success(null)
    }

    private fun connectXSensDot(call: MethodCall, result: MethodChannel.Result) {
        val address = call.argument<String>("address")
        if (address == null) {
            result.error(ErrorCodes.ArgNotSet.code, "address argument not set", null);
            return
        }
        val xSensDotDeviceCustomCallback = XSensDotDeviceCustomCallback()

        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val mBluetoothAdapter = bluetoothManager.adapter
        val device: BluetoothDevice =
            mBluetoothAdapter.getRemoteDevice(address)

        currentXSensDot = XsensDotDevice(context, device, xSensDotDeviceCustomCallback)

        currentXSensDot?.connect()

        result.success(null)
    }

    private fun setRate(call: MethodCall, result: MethodChannel.Result) {
        val rate: Int? = call.argument<Int>("rate")
        if (rate != null) {
            currentXSensDot?.setOutputRate(rate)
            result.success(null)
            return
        }
        result.error(ErrorCodes.ArgNotSet.code, "Rate not set", null)
    }

    private fun disconnectXSensDot(result: MethodChannel.Result) {
        currentXSensDot?.disconnect()
        xSensDotRecorder = null
        xSensDotExporter = null
        currentXSensDot = null
        result.success(null)
    }

    private fun startMeasuring(result: MethodChannel.Result) {
        currentXSensDot?.measurementMode = XsensDotPayload.PAYLOAD_TYPE_HIGH_FIDELITY_NO_MAG;
        SystemClock.sleep(sleepingTimeMs);
        currentXSensDot?.startMeasuring()
        result.success(null)
    }

    private fun stopMeasuring(result: MethodChannel.Result) {
        currentXSensDot?.stopMeasuring()
        result.success(null)
    }

    private fun enableRecordingNotification(result: MethodChannel.Result) {
        xSensDotRecorder?.enableDataRecordingNotification()
        result.success(null)
    }

    private fun startRecording(result: MethodChannel.Result) {
        xSensDotRecorder?.startRecording()
        result.success(null)
    }

    private fun stopRecording(result: MethodChannel.Result) {
        xSensDotRecorder?.stopRecording()
        result.success(null)
    }

    private fun getFlashInfo(call: MethodCall, result: MethodChannel.Result) {
        val isManagingFiles: Boolean? = call.argument<Boolean>("isManagingFiles")
        if (isManagingFiles == null) {
            result.error(ErrorCodes.ArgNotSet.code, "isManagingFiles argument not set", null)
            return
        }

        if (isManagingFiles) {
            xSensDotExporter?.getFlashInfo()
        } else {
            xSensDotRecorder?.getFlashInfo()
        }

        result.success(null)
    }

    private fun getFileInfo(result: MethodChannel.Result) {
        xSensDotExporter?.getFileInfo()
        result.success(null)
    }

    private fun prepareExtract(result: MethodChannel.Result) {
        if (xSensDotExporter != null) {
            xSensDotExporter?.clearManager()
        }

        xSensDotRecorder?.clearManager()
        xSensDotRecorder = null

        SystemClock.sleep(sleepingTimeMs)

        xSensDotExporter = XSensDotExporter(context, currentXSensDot!!)
        xSensDotExporter?.enableDataRecordingNotification()

        result.success(null)
    }

    private fun extractFile(call: MethodCall, result: MethodChannel.Result) {
        val file: String? = call.argument<String>("fileInfo")

        if (file == null) {
            result.error(ErrorCodes.ArgNotSet.code, "fileInfo argument not set", null)
            return
        }

        val fileInfo: XsensDotRecordingFileInfo? = XSensFileInfoSerializer.deserialize(file)

        if (fileInfo == null) {
            result.error(
                ErrorCodes.BadArgFormat.code,
                "fileInfo does not respect the expected format",
                null
            )
            return
        }

        val success = xSensDotExporter?.extractFile(fileInfo)

        if (success!!) {
            result.success(null)
        } else {
            result.error(ErrorCodes.ExtractFailed.code, "Failed to start extract", null)
        }

    }

    private fun prepareRecording(result: MethodChannel.Result) {
        if (xSensDotRecorder != null) {
            xSensDotRecorder?.clearManager()
        }

        xSensDotExporter?.clearManager()
        xSensDotExporter = null

        SystemClock.sleep(sleepingTimeMs)

        xSensDotRecorder = XSensDotRecorder(context, currentXSensDot!!)
        xSensDotRecorder?.enableDataRecordingNotification()

        result.success(null)
    }

    private fun eraseMemory(result: MethodChannel.Result) {
        xSensDotExporter?.eraseMemory()
        result.success(null)
    }
}
