package com.example.figure_skating_jumps.channels.event_channels

import android.util.Log
import io.flutter.plugin.common.EventChannel

interface IXSensDotEventStreamHandler<T> : EventChannel.StreamHandler {
    var sink: EventChannel.EventSink?

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        Log.i("Android", "Canceled stream")
        sink = null
    }

    fun sendEvent(event: T)
}