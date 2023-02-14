import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/enums/user_role.dart';
import 'package:figure_skating_jumps/models/capture.dart';

class SkatingUser {
  late String? uID;
  late String _firstName;
  late String _lastName;
  late UserRole _role;
  final List<Capture> _captures = <Capture>[];
  final List<SkatingUser> _trainees = <
      SkatingUser>[]; //TODO when creating skaters -> decides if whe keep a list of User or only their UID
  final List<SkatingUser> _coaches = <SkatingUser>[];

  String get firstName {
    return _firstName;
  }

  String get lastName {
    return _lastName;
  }

  UserRole get role {
    return _role;
  }

  List<Capture> get captures {
    return _captures;
  }

  List<SkatingUser> get trainees {
    return _trainees;
  }

  List<SkatingUser> get coaches {
    return _coaches;
  }

  SkatingUser(this._firstName, this._lastName, this._role);

  SkatingUser.fromFirestore(
      this.uID, DocumentSnapshot<Map<String, dynamic>> userInfo) {
    String firstName = userInfo.get('firstName');
    String lastName = userInfo.get('lastName');

    String roleStr = userInfo.get('role');
    UserRole role = UserRole.values
        .firstWhere((element) => element.toString() == roleStr);

    SkatingUser(firstName, lastName, role);
    //TODO convert json to list when saving acquisition and when linking trainee and coach
  }
}
