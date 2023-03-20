import 'abstract_local_db_object.dart';

class DeviceNames extends AbstractLocalDbObject {
  final String _userID;
  final String _deviceMacAddress;
  String name;

  DeviceNames(
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
      'id': id,
      'userID': _userID,
      'deviceMacAddresses': _deviceMacAddress,
    };
  }

  @override
  String toString() {
    return 'DeviceNames{id: $id, userID: $_userID, deviceMacAddresses: $_deviceMacAddress}';
  }
}
