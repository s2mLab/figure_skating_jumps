package com.example.figure_skating_jumps.channels.event_channels

import android.bluetooth.BluetoothDevice
import io.flutter.plugin.common.EventChannel

/**
 * A class that implements [XSensDotEventStreamHandler]
 * to handle bluetooth scan stream events
 */
object XSensDotScanStreamHandler : XSensDotEventStreamHandler<BluetoothDevice>() {
    /**
     * Send bluetooth scan events to the flutter project
     *
     * @param event The event to send
     */
   override fun sendEvent(event: BluetoothDevice) {
       handler.post {
           try {
               sink?.success("${event.address},${event.alias}")
           } catch (e: SecurityException) {
               sink?.error("security", e.message, e.stackTrace)
           }
       }
    }
}