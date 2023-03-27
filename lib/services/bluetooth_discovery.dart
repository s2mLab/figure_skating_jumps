import 'dart:async';

import 'package:figure_skating_jumps/interfaces/i_bluetooth_discovery_subscriber.dart';
import 'package:figure_skating_jumps/interfaces/i_observable.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_channel_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../enums/event_channel_names.dart';

class BluetoothDiscovery
    implements
        IObservable<IBluetoothDiscoverySubscriber, List<BluetoothDevice>> {
  static final BluetoothDiscovery _bluetoothDiscovery =
      BluetoothDiscovery._internal();
  final List<IBluetoothDiscoverySubscriber> _subscribers = [];
  static final List<BluetoothDevice> _devices = [];
  static final _xSensScanChannel =
      EventChannel(EventChannelNames.scanChannel.channelName);
  static const _scanDuration = Duration(seconds: 30);

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory BluetoothDiscovery() {
    _xSensScanChannel.receiveBroadcastStream().listen((event) {
      _addDevice(event as String);
    });
    return _bluetoothDiscovery;
  }

  BluetoothDiscovery._internal();

  List<BluetoothDevice> getDevices() {
    return [
      ..._devices
    ]; //Deep copy for now, might be relevant to shallow copy in the end
  }

  void scanDevices() async {
    _devices.clear();
    await XSensDotChannelService().startScan();
    Timer(_scanDuration, () async {
      await XSensDotChannelService().stopScan();
    });
  }

  static void _addDevice(String eventDevice) {
    var device = BluetoothDevice.fromEvent(eventDevice);
    if (_devices.indexWhere((el) => el.macAddress == device.macAddress) != -1) {
      return;
    }
    _devices.add(device);
    BluetoothDiscovery().notifySubscribers(_devices);
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
