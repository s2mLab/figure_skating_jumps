class UserPreferences {
  final int _id;
  final String _uID;
  String _deviceMacAddresses;

  UserPreferences(
      {required int id,
      required String uID,
      required String deviceMacAddresses})
      : _deviceMacAddresses = deviceMacAddresses,
        _uID = uID,
        _id = id;

  get deviceMacAddresses {
    return _deviceMacAddresses;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'uID': _uID,
      'deviceMacAddresses': _deviceMacAddresses,
    };
  }

  void addAddress(String macAddress) {
    _deviceMacAddresses += _deviceMacAddresses.trim().isEmpty ? macAddress : '|$macAddress';
  }

  @override
  String toString() {
    return 'UserPreferences{id: $_id, uID: $_uID, deviceMacAddresses: $_deviceMacAddresses}';
  }


}
