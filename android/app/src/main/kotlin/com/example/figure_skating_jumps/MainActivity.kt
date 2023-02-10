package com.example.figure_skating_jumps

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

import com.xsens.dot.android.sdk.models.XsensDotProductId

class MainActivity : FlutterActivity() {
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
            "exampleXSens" -> exampleXsens(call, result)
            else -> result.notImplemented()
        }
    }

    //Had the specific methods here
    //This is an example with arguments
    private fun exampleXsens(call: MethodCall, result: MethodChannel.Result) {
        if (call.argument<String>("version") == "V1") {
            result.success(XsensDotProductId.V1)
        } else if (call.argument<String>("version") == "V2") {
            result.success(XsensDotProductId.V2)
        } else {
            result.success(XsensDotProductId.UNKNOWN)
        }
    }
}
