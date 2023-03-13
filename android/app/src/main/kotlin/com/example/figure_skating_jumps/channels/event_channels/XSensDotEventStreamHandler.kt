package com.example.figure_skating_jumps.channels.event_channels

import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.EventChannel

abstract class XSensDotEventStreamHandler<T> : EventChannel.StreamHandler {
    var sink: EventChannel.EventSink? = null
    val handler: Handler = Handler(Looper.getMainLooper())

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        Log.i("Android", "Canceled stream")
        sink = null
    }

    abstract fun sendEvent(event: T)
}