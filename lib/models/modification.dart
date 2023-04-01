import 'package:cloud_firestore/cloud_firestore.dart';

class Modification {
  final DateTime _date;
  final String _action;

  get date {
    return _date;
  }

  get action {
    return _action;
  }

  Modification(String action, DateTime date)
      : _date = date,
        _action = action;

  static Modification buildFromMap(Map<String, dynamic> map) {
    return Modification(map['action'], (map['date'] as Timestamp).toDate());
  }
}
