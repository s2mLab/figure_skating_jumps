import 'dart:math';

import 'package:figure_skating_jumps/enums/user_role.dart';
import 'package:figure_skating_jumps/exceptions/conflict_exception.dart';
import 'package:figure_skating_jumps/exceptions/null_user_exception.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/services/manager/device_names_manager.dart';
import 'package:figure_skating_jumps/utils/exception_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

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

  Future<String> signUp(
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
    userInfo.uID = userCreds.user?.uid;
    try {
      await _firestore.collection(_userCollectionString).doc(userInfo.uID).set({
        'firstName': userInfo.firstName,
        'lastName': userInfo.lastName,
        'email': email,
        'role': userInfo.role.toString(),
        'captures': userInfo.capturesID,
        'trainees': userInfo.trainees,
        'coaches': userInfo.coachesID,
      });
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
    return userCreds.user!.uid;
  }

  /// Signs in the user with the give [email] and [password].
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (_firebaseAuth.currentUser == null) {
        throw NullUserException();
      }

      DocumentSnapshot<Map<String, dynamic>> userInfoSnapshot = await _firestore
          .collection(_userCollectionString)
          .doc(_firebaseAuth.currentUser?.uid)
          .get();
      _currentSkatingUser = SkatingUser.fromFirestore(
          _firebaseAuth.currentUser?.uid, userInfoSnapshot);

      await DeviceNamesManager()
          .loadDeviceNames(_firebaseAuth.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      ExceptionUtils.handleFirebaseAuthException(e);
      developer.log(e.toString());
      rethrow;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _currentSkatingUser = null;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  Future<void> delete() async {
    try {
      if (_firebaseAuth.currentUser == null) {
        throw NullUserException();
      }
      String? uID = _firebaseAuth.currentUser?.uid;
      await _firebaseAuth.currentUser?.delete();
      await _firestore.collection(_userCollectionString).doc(uID).delete();
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  /// Put in a try catch. Throws an exception when there is an error during the operation
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

  Future<void> changePassword(
      {required String userID, required String password}) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(password);
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

  Future<String> createAndLinkSkater(
      {required String skaterEmail,
      required String coachId,
      required String firstName,
      required String lastName}) async {
    QuerySnapshot<Map<String, dynamic>> result = await _firestore
        .collection(_userCollectionString)
        .where("email", isEqualTo: skaterEmail)
        .get();
    SkatingUser skatingUser =
        SkatingUser(firstName, lastName, UserRole.iceSkater);
    if (result.docs.isEmpty) {
      Random rnd = Random.secure();
      const chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      String password =
          List.generate(64, (index) => chars[rnd.nextInt(chars.length)]).join();
      // Signs up the user with a temporary random password
      String uID = await signUp(
          email: skaterEmail, password: password, userInfo: skatingUser);
      skatingUser.uID = uID;
      await resetPassword(email: skaterEmail);
    } else if (result.docs.length == 1) {
      skatingUser =
          SkatingUser.fromFirestore(result.docs[0].id, result.docs[0]);
    } else {
      throw ConflictException();
    }
    // The id was set in both branches
    await linkSkaterAndCoach(skaterId: skatingUser.uID!, coachId: coachId);
    return skatingUser.uID!;
  }

  Future<void> linkSkaterAndCoach(
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
          .set({"trainees": coach.trainees}, SetOptions(merge: true));
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

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
      coach.trainees.removeWhere((element) => element.uID! == skaterId);
      _currentSkatingUser!.coachesID
          .removeWhere((element) => element == coachId);

      await _firestore
          .collection(_userCollectionString)
          .doc(skaterId)
          .set({"coaches": skater.coachesID}, SetOptions(merge: true));
      await _firestore
          .collection(_userCollectionString)
          .doc(coachId)
          .set({"trainees": coach.trainees}, SetOptions(merge: true));
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }
}
