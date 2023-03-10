package com.example.figure_skating_jumps.event_channels

import android.bluetooth.BluetoothDevice
import io.flutter.plugin.common.EventChannel

object XSensDotScanStreamHandler : IXSensDotEventStreamHandler<BluetoothDevice> {
    override var sink: EventChannel.EventSink? = null

    override fun sendEvent(event: BluetoothDevice) {
        sink?.success(event)
    }
}