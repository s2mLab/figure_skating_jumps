import 'dart:async';

import 'package:figure_skating_jumps/interfaces/i_bluetooth_discovery_subscriber.dart';
import 'package:figure_skating_jumps/interfaces/i_observable.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../enums/event_channel_names.dart';
import '../../enums/method_channel_names.dart';

class XSensDotBluetoothDiscoveryService
    implements
        IObservable<IBluetoothDiscoverySubscriber, List<BluetoothDevice>> {
  static final XSensDotBluetoothDiscoveryService _bluetoothDiscovery =
      XSensDotBluetoothDiscoveryService._internal();
  final List<IBluetoothDiscoverySubscriber> _subscribers = [];
  static final List<BluetoothDevice> _devices = [];
  static final _xSensScanChannel =
      EventChannel(EventChannelNames.scanChannel.channelName);
  static final _xSensScanMethodChannel = MethodChannel(MethodChannelNames.scanChannel.channelName);
  static const _scanDuration = Duration(seconds: 30);

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory XSensDotBluetoothDiscoveryService() {
    _xSensScanChannel.receiveBroadcastStream().listen((event) {
      _addDevice(event as String);
    });
    return _bluetoothDiscovery;
  }

  XSensDotBluetoothDiscoveryService._internal();

  List<BluetoothDevice> getDevices() {
    return [
      ..._devices
    ]; //Deep copy for now, might be relevant to shallow copy in the end
  }

  Future<void> scanDevices() async {
    _devices.clear();
    await _startScan();
    Timer(_scanDuration, () async {
      await _stopScan();
    });
  }

  Future<void> _startScan() async {
    try {
      await _xSensScanMethodChannel.invokeMethod('startScan');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  Future<void> _stopScan() async {
    try {
      await _xSensScanMethodChannel.invokeMethod('stopScan');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  static void _addDevice(String eventDevice) {
    var device = BluetoothDevice.fromEvent(eventDevice);
    if (_devices.indexWhere((el) => el.macAddress == device.macAddress) != -1) {
      return;
    }
    _devices.add(device);
    XSensDotBluetoothDiscoveryService().notifySubscribers(_devices);
  }

  @override
  @protected
  void notifySubscribers(List<BluetoothDevice> devices) {
    for (IBluetoothDiscoverySubscriber s in _subscribers) {
      s.onBluetoothDeviceListChange(devices);
    }
  }

  @override
  List<BluetoothDevice> subscribe(IBluetoothDiscoverySubscriber subscriber) {
    _subscribers.add(subscriber);
    return getDevices();
  }

  @override
  void unsubscribe(IBluetoothDiscoverySubscriber subscriber) {
    _subscribers.remove(subscriber);
  }
}
