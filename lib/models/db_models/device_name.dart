import 'abstract_local_db_object.dart';

class DeviceName extends AbstractLocalDbObject {
  final String _userID;
  final String _deviceMacAddress;
  String name;

  DeviceName(
      {int? id,
      required String userID,
      required String deviceMacAddress,
      required this.name})
      : _deviceMacAddress = deviceMacAddress,
        _userID = userID {
    this.id = id;
  }

  get deviceMacAddress {
    return _deviceMacAddress;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'userID': _userID,
      'deviceMacAddress': _deviceMacAddress,
      'customName': name,
    };
  }

  @override
  String toString() {
    return 'DeviceName{id: $id, userID: $_userID, name: $name, deviceMacAddress: $_deviceMacAddress}';
  }
}
