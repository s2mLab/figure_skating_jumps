import 'dart:async';

import 'package:figure_skating_jumps/interfaces/i_bluetooth_discovery_subscriber.dart';
import 'package:figure_skating_jumps/interfaces/i_observable.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_channel_service.dart';
import 'package:flutter/material.dart';

class BluetoothDiscovery implements IObservable<IBluetoothDiscoverySubscriber, List<BluetoothDevice>> {

  static final BluetoothDiscovery _bluetoothDiscovery =
      BluetoothDiscovery._internal();
  final List<IBluetoothDiscoverySubscriber> _subscribers = [];
  List<BluetoothDevice> _devices = [];
  static const _scanDuration = Duration(seconds: 3);

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory BluetoothDiscovery() {
    return _bluetoothDiscovery;
  }

  Duration get scanDuration {
    return _scanDuration;
  }

  BluetoothDiscovery._internal();

  List<BluetoothDevice> getDevices() {
    return [
      ..._devices
    ]; //Deep copy for now, might be relevant to shallow copy in the end
  }

  void refreshFromKotlinHandle() async {
    await XSensDotChannelService().startScan();
    Timer(_scanDuration, () async {
      _devices = await XSensDotChannelService().stopScan();
      notifySubscribers(getDevices());
    });
  }

  @override
  @protected void notifySubscribers(List<BluetoothDevice> devices) {
    for (IBluetoothDiscoverySubscriber s in _subscribers) {
      s.onBluetoothDeviceListChange(devices);
    }
  }

  @override
  List<BluetoothDevice> subscribe(IBluetoothDiscoverySubscriber subscriber) {
    _subscribers.add(subscriber);
    return getDevices();
  }
}
