import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/local_db/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/local_db/local_db_service.dart';
import 'package:flutter/cupertino.dart';

class BluetoothDeviceManager implements ILocalDbManager<BluetoothDevice> {
  static final BluetoothDeviceManager _bluetoothDeviceManager =
      BluetoothDeviceManager._internal();

  List<BluetoothDevice> _devices = [];

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory BluetoothDeviceManager() {
    return _bluetoothDeviceManager;
  }

  BluetoothDeviceManager._internal();

  List<BluetoothDevice> get devices {
    return _devices;
  }

  @override
  List<BluetoothDevice> constructObject(List<Map<String, dynamic>> objMaps) {
    return List.generate(objMaps.length, (i) {
      return BluetoothDevice(
        id: objMaps[i]['id'],
        userId: objMaps[i]['userId'],
        macAddress: objMaps[i]['macAddress'],
        name: objMaps[i]['name'],
      );
    });
  }

  /// Loads the Bluetooth devices for the given user ID from the local database.
  ///
  /// Parameters:
  /// - [userID] : The ID of the user whose devices to load.
  ///
  /// Returns void.
  Future<void> loadDevices(String userID) async {
    _devices = constructObject(await LocalDbService()
        .readWhere(LocalDbService.bluetoothDeviceTableName, "userID", userID));
  }

  /// Adds a [BluetoothDevice] to the user's known devices.
  ///
  /// Parameters:
  /// - [device] : The [BluetoothDevice] object to add.
  ///
  /// Returns void.
  Future<void> addDevice(BluetoothDevice device) async {
    int id = await LocalDbService()
        .insertOne(device, LocalDbService.bluetoothDeviceTableName);
    device.id = id;
    _devices.add(device);
  }

  /// Removes the given [device] from the users known devices.
  ///
  /// Parameters:
  /// - [device] : the [BluetoothDevice] to be removed.
  ///
  /// Returns void.
  Future<void> removeDevice(BluetoothDevice device) async {
    if (!_devices.any((element) => element.macAddress == device.macAddress)) {
      debugPrint("Could not find device ${device.macAddress} in local storage");
      return;
    }
    _devices.removeWhere((element) => element.macAddress == device.macAddress);
    await LocalDbService()
        .deleteOne(device, LocalDbService.bluetoothDeviceTableName);
  }

  /// Updates the given [device] in the users known devices.
  ///
  /// Parameters:
  /// - [device] : the [BluetoothDevice] to be updated.
  ///
  /// Returns void.
  Future<void> updateDevice(BluetoothDevice device) async {
    await LocalDbService()
        .updateOne(device, LocalDbService.bluetoothDeviceTableName);
  }
}
