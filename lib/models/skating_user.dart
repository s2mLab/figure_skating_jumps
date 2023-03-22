import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/enums/user_role.dart';

class SkatingUser {
  static const String _userCollectionString = 'users';

  late String? uID;
  late String _firstName;
  late String _lastName;
  late UserRole _role;
  late String _email;
  late List<String> _captures = [];
  late List<String> _traineesID = [];
  late List<SkatingUser> _trainees = [];
  final List<String> _coaches = [];

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

  List<String> get captures {
    return _captures;
  }

  List<SkatingUser> get trainees {
    return _trainees;
  }

  List<String> get traineesID {
    return _traineesID;
  }

  List<String> get coaches {
    return _coaches;
  }

  loadTrainees() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    _trainees = [];
    for (String id in _traineesID) {
      SkatingUser trainee = SkatingUser.fromFirestore(
          id, await firestore.collection(_userCollectionString).doc(id).get());
      _trainees.add(trainee);
    }
  }

  SkatingUser(this._firstName, this._lastName, this._role, [this.uID]);

  factory SkatingUser.fromFirestore(
      uID, DocumentSnapshot<Map<String, dynamic>> userInfo) {
    String firstName = userInfo.get('firstName');
    String lastName = userInfo.get('lastName');
    String roleStr = userInfo.get('role');
    UserRole role =
        UserRole.values.firstWhere((element) => element.toString() == roleStr);

    SkatingUser skaterUser = SkatingUser(firstName, lastName, role, uID);

    skaterUser._captures = List<String>.from(userInfo.get('captures') as List);
    skaterUser._traineesID =
        List<String>.from(userInfo.get('trainees') as List);
    return skaterUser;
    //TODO convert json to list when saving acquisition and when linking trainee and coach
  }
}
