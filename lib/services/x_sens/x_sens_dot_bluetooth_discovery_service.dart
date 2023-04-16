import 'dart:async';
import 'package:figure_skating_jumps/enums/event_channel_names.dart';
import 'package:figure_skating_jumps/enums/method_channel_names.dart';
import 'package:figure_skating_jumps/interfaces/i_bluetooth_discovery_subscriber.dart';
import 'package:figure_skating_jumps/interfaces/i_observable.dart';
import 'package:figure_skating_jumps/models/local_db/bluetooth_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class XSensDotBluetoothDiscoveryService
    implements
        IObservable<IBluetoothDiscoverySubscriber, List<BluetoothDevice>> {
  static final XSensDotBluetoothDiscoveryService _bluetoothDiscovery =
      XSensDotBluetoothDiscoveryService._internal();
  final List<IBluetoothDiscoverySubscriber> _subscribers = [];
  static final List<BluetoothDevice> _devices = [];
  static final _xSensScanChannel =
      EventChannel(EventChannelNames.scanChannel.channelName);
  static final _bluetoothEventChannel =
      EventChannel(EventChannelNames.bluetoothChannel.channelName);
  static final _xSensScanMethodChannel =
      MethodChannel(MethodChannelNames.scanChannel.channelName);
  static final _bluetoothMethodChannel =
      MethodChannel(MethodChannelNames.bluetoothChannel.channelName);
  static const _scanRefreshRate = Duration(seconds: 30);
  static Timer? _scanTimer;

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory XSensDotBluetoothDiscoveryService() {
    _xSensScanChannel.receiveBroadcastStream().listen((event) {
      _addDevice(event as String);
    });

    _bluetoothEventChannel.receiveBroadcastStream().listen((event) {
      _handleBluetoothEvent(event as bool);
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
    try {
      await _bluetoothMethodChannel.invokeMethod('managePermissions');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  static Future<void> _setUpScan() async {
    if (_scanTimer != null) {
      _scanTimer?.cancel();
    } else {
      await _startScan();
    }
    _scanTimer = Timer.periodic(_scanRefreshRate, (_) {
      _devices.clear();
      XSensDotBluetoothDiscoveryService().notifySubscribers(_devices);
    });
  }

  static Future<void> _startScan() async {
    _devices.clear();
    try {
      await _xSensScanMethodChannel.invokeMethod('startScan');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  static Future<void> _stopScan() async {
    try {
      await _xSensScanMethodChannel.invokeMethod('stopScan');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  static Future<void> _handleBluetoothEvent(bool bluetoothEvent) async {
    if (bluetoothEvent) {
      await _setUpScan();
    }
  }

  static void _addDevice(String eventDevice) {
    var device = BluetoothDevice.fromEvent(eventDevice);
    if (_devices.any((el) => el.macAddress == device.macAddress)) {
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
    if (_subscribers.isEmpty) {
      _scanTimer?.cancel();
      _scanTimer = null;
      //We do not need to await there, the scan will stop after a few ms
      _stopScan();
    }
  }
}
