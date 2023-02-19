import 'package:figure_skating_jumps/models/bluetooth_device.dart';

class XSensDeserializer {
  static BluetoothDevice? deserialize(Object? rawObject) {
    if (rawObject != null) {
      List<String> splitObject = rawObject.toString().split(", ");

      if (splitObject.length != 2) return null;

      String macAddress = splitObject.first.replaceFirst("(", "");
      String name = splitObject.last
          .replaceFirst(")", "", splitObject.last.length - 1);

      return BluetoothDevice(macAddress, name);
    }
    return null;
  }
}
