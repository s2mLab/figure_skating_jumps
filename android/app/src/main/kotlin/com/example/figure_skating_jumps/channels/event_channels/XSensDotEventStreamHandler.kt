package com.example.figure_skating_jumps.channels.event_channels

import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.EventChannel

/**
 * An abstract class that implements [EventChannel.StreamHandler] to handle stream events from an XSensDot device
 *
 * @param T The event type this handler will handle
 */
abstract class XSensDotEventStreamHandler<T> : EventChannel.StreamHandler {
    var sink: EventChannel.EventSink? = null
    val handler: Handler = Handler(Looper.getMainLooper())

    /**
     * Called when the stream is being listened to
     *
     * @param arguments Any arguments passed to the stream handler
     * @param events The event sink to send events to
     */
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.i("XSensDotEventStreamHandler", "Listen stream")
        sink = events
    }

    /**
     * Called when the stream is being cancelled
     *
     * @param arguments Any arguments passed to the stream handler
     */
    override fun onCancel(arguments: Any?) {
        Log.i("XSensDotEventStreamHandler", "Cancel stream")
        sink = null
    }

    /**
     * An abstract method to be implemented by the subclass to send events of type [T]
     * to the flutter project
     *
     * @param event The event to send
     */
    abstract fun sendEvent(event: T)
}