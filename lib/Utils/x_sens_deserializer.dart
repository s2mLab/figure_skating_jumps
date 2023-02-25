import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/models/xsens_dot_data.dart';
import 'package:flutter/material.dart';

class XSensDeserializer {
  static List<BluetoothDevice> deserializeDevice(String rawObject) {
    List<BluetoothDevice> devices = [];
    List<String> splitObject = rawObject.toString().split("), (");
    splitObject.first = splitObject.first.replaceFirst("[(", "");
    splitObject.last =
        splitObject.last.replaceFirst(")]", "", splitObject.last.length - 2);
    for (var stringDevice in splitObject) {
      List<String> splitDevice = stringDevice.split(", ");
      if (splitDevice.length != 2) continue;

      String macAddress = splitDevice.first;
      String name = splitDevice.last;

      devices.add(BluetoothDevice(macAddress, name));
    }

    return devices;
  }

  static List<XSensDotData> deserializeData(String rawObject) {
    debugPrint(rawObject);
    List<XSensDotData> devices = [];

    return devices;
  }
}
