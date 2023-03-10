package com.example.figure_skating_jumps

import android.util.Log
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.EventChannel.EventSink

object EventStreamHandler : StreamHandler {
    private var sink: EventSink? = null

    override fun onListen(arguments: Any?, events: EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        Log.i("Android", "Canceled stream")
    }

    fun sendEvent(event: String) {
        sink?.success(event)
    }
}