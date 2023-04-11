import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/enums/user_role.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';
import 'package:figure_skating_jumps/services/user_client.dart';

class SkatingUser {
  late String? uID;
  late String _firstName;
  late String _lastName;
  late UserRole role;
  late String _email;
  late List<String> _capturesID = [];
  late List<String> _traineesID = [];
  final List<SkatingUser> _trainees = [];
  late List<String> _coachesID = [];
  final List<SkatingUser> _coaches = [];

  String get firstName {
    return _firstName;
  }

  String get lastName {
    return _lastName;
  }

  String get name {
    return "$_firstName $_lastName";
  }

  set firstName(String newName) {
    if (newName.isNotEmpty) {
      _firstName = newName;
    }
  }

  set lastName(String newName) {
    if (newName.isNotEmpty) {
      _lastName = newName;
    }
  }

  String get email {
    return _email;
  }

  List<String> get capturesID {
    return _capturesID;
  }

  List<SkatingUser> get trainees {
    return _trainees;
  }

  List<String> get traineesID {
    return _traineesID;
  }

  List<SkatingUser> get coaches {
    return _coaches;
  }

  List<String> get coachesID {
    return _coachesID;
  }

  Future<void> loadCoaches() async {
    _coaches.clear();
    for (String id in _coachesID) {
      SkatingUser coach = await UserClient().getUserById(id: id);
      _coaches.add(coach);
    }
  }

  Future<void> loadTrainees() async {
    _trainees.clear();
    for (String id in _traineesID) {
      SkatingUser trainee = await UserClient().getUserById(id: id);
      _trainees.add(trainee);
    }
  }

  SkatingUser(this._firstName, this._lastName, this.role, this._email,
      [this.uID]);

  Future<List<Capture>> getCapturesData() async {
    List<Capture> captures = [];
    for (String captureID in _capturesID) {
      captures.add(await CaptureClient().getCaptureByID(uID: captureID));
    }
    return captures;
  }

  factory SkatingUser.fromFirestore(
      uID, DocumentSnapshot<Map<String, dynamic>> userInfo) {
    String firstName = userInfo.get('firstName');
    String lastName = userInfo.get('lastName');
    String email = userInfo.get('email');
    String roleStr = userInfo.get('role');
    UserRole role =
        UserRole.values.firstWhere((element) => element.toString() == roleStr);

    SkatingUser skaterUser = SkatingUser(firstName, lastName, role, email, uID);

    skaterUser._capturesID =
        List<String>.from(userInfo.get('captures') as List);
    skaterUser._traineesID =
        List<String>.from(userInfo.get('trainees') as List);
    skaterUser._coachesID = List<String>.from(userInfo.get('coaches') as List);
    return skaterUser;
  }
}
