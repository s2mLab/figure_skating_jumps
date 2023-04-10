import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/local_db_service.dart';
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

  Future<void> loadDevices(String userID) async {
    _devices = constructObject(await LocalDbService()
        .readWhere(LocalDbService.bluetoothDeviceTableName, "userID", userID));
  }

  Future<void> addDevice(BluetoothDevice device) async {
    int id = await LocalDbService()
        .insertOne(device, LocalDbService.bluetoothDeviceTableName);
    device.id = id;
    _devices.add(device);
  }

  Future<void> removeDevice(BluetoothDevice device) async {
    if (!_devices.remove(device)) {
      debugPrint("Could not find device ${device.macAddress} in local storage");
      return;
    }
    await LocalDbService()
        .deleteOne(device, LocalDbService.bluetoothDeviceTableName);
  }

  Future<void> updateDevice(BluetoothDevice device) async {
    await LocalDbService()
        .updateOne(device, LocalDbService.bluetoothDeviceTableName);
  }
}
