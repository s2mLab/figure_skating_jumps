import 'package:figure_skating_jumps/constants/generator_constants.dart';
import 'package:figure_skating_jumps/enums/models/user_role.dart';
import 'package:figure_skating_jumps/exceptions/conflict_exception.dart';
import 'package:figure_skating_jumps/exceptions/null_user_exception.dart';
import 'package:figure_skating_jumps/models/firebase/skating_user.dart';
import 'package:figure_skating_jumps/services/local_db/active_session_manager.dart';
import 'package:figure_skating_jumps/services/local_db/bluetooth_device_manager.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/utils/exception_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;
import 'dart:math';

/// A singleton used to communicate with Firebase.
/// It handles anything related to users, both storage and authentication.
class UserClient {
  static final UserClient _userClient = UserClient._internal();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SkatingUser? _currentSkatingUser;

  static const String _userCollectionString = 'users';

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory UserClient() {
    return _userClient;
  }

  UserClient._internal();

  User? get currentAuthUser {
    return _firebaseAuth.currentUser;
  }

  SkatingUser? get currentSkatingUser {
    return _currentSkatingUser;
  }

  /// Registers a new user with the provided email and password, and saves their info to the database.
  ///
  /// Throws a [FirebaseException] if an error occurs during the registration process or database write.
  ///
  /// Parameters:
  /// - [email] : The user's email address as a [String].
  /// - [password] : The user's password as a [String].
  /// - [userInfo] : The [SkatingUser] object containing the user's information.
  ///
  /// Returns the user's unique ID as a [String].
  Future<String> signUp(
      {required String email,
      required String password,
      required SkatingUser userInfo}) async {
    String uID = await _createUserInDb(
        email: email, password: password, userInfo: userInfo);
    _currentSkatingUser = userInfo;
    return uID;
  }

  /// Signs in a user with the given email and password.
  /// It will set [_currentSkatingUser] to the user associated with the given email and password
  /// and saves an active session with the given email and password to allow easy login later.
  /// It also loads the user's Bluetooth devices.
  ///
  /// Throws a [FirebaseAuthException] if an error occurs.
  ///
  /// Parameters:
  /// - [email] : a [String] representing the user's email
  /// - [password] : a [String] representing the user's password
  ///
  /// Returns void.
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (_firebaseAuth.currentUser == null) {
        throw NullUserException();
      }

      DocumentSnapshot<Map<String, dynamic>> userInfoSnapshot = await _firestore
          .collection(_userCollectionString)
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      _currentSkatingUser = SkatingUser.fromFirestore(
          _firebaseAuth.currentUser?.uid, userInfoSnapshot);

      await ActiveSessionManager().saveActiveSession(email, password);

      await BluetoothDeviceManager()
          .loadDevices(_firebaseAuth.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      ExceptionUtils.handleFirebaseAuthException(e);
      developer.log(e.toString());
      rethrow;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  /// Signs out the current user and clears the active session.
  ///
  /// Throws a [FirebaseAuthException] if sign out fails.
  ///
  /// Returns void.
  Future<void> signOut() async {
    try {
      await XSensDotConnectionService().disconnect();
      await _firebaseAuth.signOut();
      await ActiveSessionManager().clearActiveSession();
      _currentSkatingUser = null;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  /// Returns a [SkatingUser] by their [id].
  ///
  /// Throws a [FirebaseAuthException] if the user information cannot be retrieved.
  ///
  /// Parameters:
  /// - [id] : The [String] ID of the [SkatingUser] to retrieve.
  ///
  /// Returns the [SkatingUser] object of the specified [id].
  Future<SkatingUser> getUserById({required String id}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userInfo =
          await _firestore.collection(_userCollectionString).doc(id).get();
      return SkatingUser.fromFirestore(id, userInfo);
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  /// Changes the first and last name of a user in the database.
  ///
  /// Throws a [FirebaseAuthException] if an error occurs.
  ///
  /// Parameters:
  /// - [userID] : the ID of the user whose name is being changed.
  /// - [firstName] : the new first name of the user.
  /// - [lastName] : the new last name of the user.
  ///
  /// Returns void.
  Future<void> changeName(
      {required String userID,
      required String firstName,
      required String lastName}) async {
    try {
      await _firestore.collection(_userCollectionString).doc(userID).set(
          {"firstName": firstName, "lastName": lastName},
          SetOptions(merge: true));
      _currentSkatingUser!.firstName = firstName;
      _currentSkatingUser!.lastName = lastName;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  /// Changes the role of a user identified by the given [userID].
  ///
  /// Throws a [FirebaseAuthException] if an error occurs during the process.
  ///
  /// Parameters:
  /// - [userID] : A [String] representing the ID of the user whose role is to be changed.
  /// - [role] : A [UserRole] representing the new role for the user.
  ///
  /// Returns void.
  Future<void> changeRole(
      {required String userID, required UserRole role}) async {
    try {
      await _firestore
          .collection(_userCollectionString)
          .doc(userID)
          .set({"role": role.toString()}, SetOptions(merge: true));
      _currentSkatingUser!.role = role;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  /// Changes the password of the user with the provided [email] and [oldPassword] to the provided [password].
  ///
  /// Throws a [FirebaseAuthException] if the Firebase authentication fails.
  ///
  /// Parameters:
  /// - [email] : The email of the user whose password is to be changed.
  /// - [oldPassword] : The old password of the user.
  /// - [password] : The new password for the user.
  ///
  /// Returns void.
  Future<void> changePassword(
      {required String email, required String oldPassword, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: oldPassword);
      await _firebaseAuth.currentUser?.updatePassword(password);
      await ActiveSessionManager().changeSessionPassword(password);
    } on FirebaseAuthException catch (e) {
      ExceptionUtils.handleFirebaseAuthException(e);
      // Should not reach this line but kept in to make sure the exception is handled
      developer.log(e.toString());
      rethrow;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  /// Sends a password reset email to the specified email address.
  ///
  /// Throws a [FirebaseAuthException] if there is an error with sending the password reset email.
  ///
  /// Parameters:
  /// - [email] : The email address of the user who needs to reset their password.
  ///
  /// Returns void.
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      ExceptionUtils.handleFirebaseAuthException(e);
      // Should not reach this line but kept in to make sure the exception is handled
      developer.log(e.toString());
      rethrow;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  /// Creates a new user and links them to a coach user in the database.
  ///
  /// Throws a [ConflictException] if the provided skater email already exists in the database.
  /// Throws a [FirebaseAuthException] if there is an error in the database.
  ///
  /// Parameters:
  /// - [skaterEmail] : the email of the skater to be created
  /// - [coachId] : the ID of the coach user to link the skater to
  /// - [firstName] : the first name of the skater to be created
  /// - [lastName] : the last name of the skater to be created
  ///
  /// Returns a [String] representing the ID of the newly created skater user.
  Future<String> createAndLinkSkater(
      {required String skaterEmail,
      required String coachId,
      required String firstName,
      required String lastName}) async {
    QuerySnapshot<Map<String, dynamic>> result = await _firestore
        .collection(_userCollectionString)
        .where("email", isEqualTo: skaterEmail)
        .get();
    if (result.docs.isNotEmpty) throw ConflictException();

    SkatingUser skatingUser =
        SkatingUser(firstName, lastName, UserRole.iceSkater, skaterEmail);
    String password = _genPassword();
    // Signs up the user with a temporary random password
    String uID = await _createUserInDb(
        email: skaterEmail, password: password, userInfo: skatingUser);
    skatingUser.uID = uID;
    await resetPassword(email: skaterEmail);

    await _linkSkaterAndCoach(skaterId: skatingUser.uID!, coachId: coachId);
    return skatingUser.uID!;
  }

  /// Links an existing Skater user to a Coach user
  ///
  /// Throws a [NullUserException] if the skater user does not exist
  /// Throws a [FirebaseAuthException] if there is an error in the database.
  ///
  /// Parameters:
  /// - [skaterEmail] : The email of the Skater user to be linked
  /// - [coachId] : The id of the Coach user to link the Skater to
  ///
  /// Returns the id of the Skater user that was linked.
  /// It can return null if the Skater was already linked to or if the skater
  /// and the coach are the same user.
  Future<String?> linkExistingSkater(
      {required String skaterEmail, required String coachId}) async {
    QuerySnapshot<Map<String, dynamic>> result = await _firestore
        .collection(_userCollectionString)
        .where("email", isEqualTo: skaterEmail)
        .get();
    if (result.docs.length != 1) throw NullUserException();

    SkatingUser skatingUser =
        SkatingUser.fromFirestore(result.docs[0].id, result.docs[0]);

    if (_currentSkatingUser!.traineesID.contains(skatingUser.uID) ||
        _currentSkatingUser!.uID == skatingUser.uID) {
      return null;
    }
    await _linkSkaterAndCoach(skaterId: skatingUser.uID!, coachId: coachId);
    return skatingUser.uID!;
  }

  /// Removes the link between a skater and a coach.
  ///
  /// Throws a [FirebaseAuthException] if there is an error in the database.
  ///
  /// Parameters:
  /// - [skaterId] : the ID of the skater to be unlinked.
  /// - [coachId] : the ID of the coach to be unlinked.
  ///
  /// Returns void.
  Future<void> unlinkSkaterAndCoach(
      {required String skaterId, required String coachId}) async {
    try {
      SkatingUser skater = SkatingUser.fromFirestore(
          skaterId,
          await _firestore
              .collection(_userCollectionString)
              .doc(skaterId)
              .get());
      SkatingUser coach = SkatingUser.fromFirestore(
          coachId,
          await _firestore
              .collection(_userCollectionString)
              .doc(coachId)
              .get());

      skater.coachesID.removeWhere((element) => element == coachId);
      coach.traineesID.removeWhere((element) => element == skaterId);

      await _firestore
          .collection(_userCollectionString)
          .doc(skaterId)
          .set({"coaches": skater.coachesID}, SetOptions(merge: true));
      await _firestore
          .collection(_userCollectionString)
          .doc(coachId)
          .set({"trainees": coach.traineesID}, SetOptions(merge: true));
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  /// Adds a capture to a user's list of captures.
  ///
  /// Throws a [FirebaseAuthException] if there is an error during the process.
  ///
  /// Parameters:
  /// - [userId] : The ID of the user to whom the capture is being added.
  /// - [captureId] : The ID of the capture to be added to the user's list of captures.
  ///
  /// Returns void.
  Future<void> linkCapture(
      {required String userId, required String captureId}) async {
    try {
      SkatingUser user = SkatingUser.fromFirestore(userId,
          await _firestore.collection(_userCollectionString).doc(userId).get());

      user.capturesID.add(captureId);

      await _firestore
          .collection(_userCollectionString)
          .doc(userId)
          .set({"captures": user.capturesID}, SetOptions(merge: true));
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  /// Generates a random secure password of 64 characters.
  ///
  /// Returns a string containing the password.
  String _genPassword() {
    Random rnd = Random.secure();
    return List.generate(64, (index) => chars[rnd.nextInt(chars.length)])
        .join();
  }

  /// Links a skater and coach together by updating their respective coach and trainee lists.
  ///
  /// Throws a [FirebaseAuthException] if any error occurs during the linking process.
  ///
  /// Parameters:
  /// - [skaterId] : A [String] representing the unique identifier of the skater.
  /// - [coachId] : A [String] representing the unique identifier of the coach.
  ///
  /// Returns void.
  Future<void> _linkSkaterAndCoach(
      {required String skaterId, required String coachId}) async {
    try {
      SkatingUser skater = SkatingUser.fromFirestore(
          skaterId,
          await _firestore
              .collection(_userCollectionString)
              .doc(skaterId)
              .get());
      SkatingUser coach = SkatingUser.fromFirestore(
          coachId,
          await _firestore
              .collection(_userCollectionString)
              .doc(coachId)
              .get());

      skater.coachesID.add(coachId);
      coach.traineesID.add(skaterId);

      await _firestore
          .collection(_userCollectionString)
          .doc(skaterId)
          .set({"coaches": skater.coachesID}, SetOptions(merge: true));
      await _firestore
          .collection(_userCollectionString)
          .doc(coachId)
          .set({"trainees": coach.traineesID}, SetOptions(merge: true));
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  /// Creates a new user in the database.
  ///
  /// Throws a [FirebaseAuthException] if an error occurs with Firebase authentication.
  /// Throws a [NullUserException] if the [userCreds] user object is null.
  ///
  /// Parameters:
  /// - [email] : the email address of the user.
  /// - [password] : the password of the user.
  /// - [userInfo] : an instance of [SkatingUser] with the user's information.
  ///
  /// Returns a [String] representing the user ID of the created user.
  Future<String> _createUserInDb(
      {required String email,
      required String password,
      required SkatingUser userInfo}) async {
    UserCredential userCreds;
    try {
      userCreds = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      ExceptionUtils.handleFirebaseAuthException(e);
      // Should not reach this line but kept in to make sure the exception is handled
      developer.log(e.toString());
      rethrow;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }

    if (userCreds.user == null) {
      throw NullUserException();
    }
    userInfo.uID = userCreds.user!.uid;
    try {
      await _firestore.collection(_userCollectionString).doc(userInfo.uID).set({
        'firstName': userInfo.firstName,
        'lastName': userInfo.lastName,
        'email': email,
        'role': userInfo.role.toString(),
        'captures': userInfo.capturesID,
        'trainees': userInfo.traineesID,
        'coaches': userInfo.coachesID,
      });
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
    return userCreds.user!.uid;
  }
}
