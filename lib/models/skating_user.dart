import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/enums/user_role.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';
import 'package:figure_skating_jumps/services/user_client.dart';

class SkatingUser {
  late String? uID;
  late String _firstName;
  late String _lastName;
  late UserRole _role;
  late String _email;
  late List<String> _capturesID = [];
  late final List<Capture> _captures = [];
  late List<String> _traineesID = [];
  late final List<SkatingUser> _trainees = [];
  late List<String> _coachesID = [];

  String get firstName {
    return _firstName;
  }

  String get lastName {
    return _lastName;
  }

  UserRole get role {
    return _role;
  }

  String get email {
    return _email;
  }

  List<String> get capturesID {
    return _capturesID;
  }

  List<Capture> get captures {
    return _captures;
  }

  Map<String, List<Capture>> get groupedCaptures {
    return groupBy(_captures, (obj) => obj.date.toString().substring(0, 10));
  }

  List<SkatingUser> get trainees {
    return _trainees;
  }

  List<String> get traineesID {
    return _traineesID;
  }

  List<String> get coachesID {
    return _coachesID;
  }

  Future<void> loadTrainees() async {
    _trainees.clear();
    for (String id in _traineesID) {
      SkatingUser trainee = await UserClient().getUserById(id: id);
      _trainees.add(trainee);
    }
  }

  Future<void> loadCapturesData() async {
    _captures.clear();
    for (String captureID in _capturesID) {
      Capture capture = await CaptureClient().getCaptureByID(uid: captureID);
      _captures.add(capture);
    }
  }

  SkatingUser(this._firstName, this._lastName, this._role, [this.uID]);

  factory SkatingUser.fromFirestore (
      uID, DocumentSnapshot<Map<String, dynamic>> userInfo) {
    String firstName = userInfo.get('firstName');
    String lastName = userInfo.get('lastName');
    String roleStr = userInfo.get('role');
    UserRole role =
        UserRole.values.firstWhere((element) => element.toString() == roleStr);

    SkatingUser skaterUser = SkatingUser(firstName, lastName, role, uID);

    skaterUser._capturesID =
        List<String>.from(userInfo.get('captures') as List);
    skaterUser._traineesID =
        List<String>.from(userInfo.get('trainees') as List);
    skaterUser._coachesID = List<String>.from(userInfo.get('coaches') as List);
    return skaterUser;
  }
}
