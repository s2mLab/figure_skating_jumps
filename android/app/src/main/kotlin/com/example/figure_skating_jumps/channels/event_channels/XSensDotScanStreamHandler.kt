package com.example.figure_skating_jumps.channels.event_channels

import android.bluetooth.BluetoothDevice
import io.flutter.plugin.common.EventChannel

object XSensDotScanStreamHandler : XSensDotEventStreamHandler<BluetoothDevice>() {
   override fun sendEvent(event: BluetoothDevice) {
       handler.post {
           sink?.success(event)
       }
    }
}