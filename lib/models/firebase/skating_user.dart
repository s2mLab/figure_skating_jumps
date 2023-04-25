import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/enums/models/user_role.dart';
import 'package:figure_skating_jumps/models/firebase/capture.dart';
import 'package:figure_skating_jumps/services/firebase/capture_client.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';

class SkatingUser {
  late String? uID;
  late UserRole role;
  late String _firstName;
  late String _lastName;
  late String _email;
  late List<String> _capturesID = [];
  late List<String> _traineesID = [];
  late List<String> _coachesID = [];

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

  List<String> get traineesID {
    return _traineesID;
  }

  List<String> get coachesID {
    return _coachesID;
  }

  SkatingUser(this._firstName, this._lastName, this.role, this._email,
      [this.uID]);

  /// Retrieves the data of every coach in this SkatingUser instance.
  ///
  /// Returns a [List] of [SkatingUser] instances.
  Future<List<SkatingUser>> getCoachesData() async {
    List<SkatingUser> coaches = [];
    for (String id in _coachesID) {
      SkatingUser coach = await UserClient().getUserById(id: id);
      coaches.add(coach);
    }
    return coaches;
  }

  /// Retrieves the data of every trainee in this SkatingUser instance.
  ///
  /// Returns a [List] of [SkatingUser] instances.
  Future<List<SkatingUser>> getTraineesData() async {
    List<SkatingUser> trainees = [];
    for (String id in _traineesID) {
      trainees.add(await UserClient().getUserById(id: id));
    }
    return trainees;
  }

  /// Retrieves the data of every capture in this SkatingUser instance.
  ///
  /// Returns a [List] of [Capture] instances.
  Future<List<Capture>> getCapturesData() async {
    List<Capture> captures = [];
    for (String captureID in _capturesID) {
      captures.add(await CaptureClient().getCaptureByID(uID: captureID));
    }
    return captures;
  }

  /// Creates a new [SkatingUser] instance from a Firestore document snapshot.
  ///
  /// Parameters:
  /// - [uID] : The user ID for the skating user.
  /// - [userInfo] : The document snapshot containing the skating user's data.
  ///
  /// Returns a new [SkatingUser] instance with the data from the provided
  /// Firestore document snapshot.
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
