import 'dart:convert';
import 'package:figure_skating_jumps/exceptions/conflict_exception.dart';
import 'package:figure_skating_jumps/exceptions/invalid_email_exception.dart';
import 'package:figure_skating_jumps/exceptions/null_user_exception.dart';
import 'package:figure_skating_jumps/exceptions/weak_password_exception.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
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

  Future<void> signUp(
      String email, String password, SkatingUser userInfo) async {
    UserCredential userCreds;
    try {
      userCreds = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          throw ConflictException();
        case "invalid-email":
          throw InvalidEmailException();
        case "weak-password":
          throw WeakPasswordException();
        default:
          developer.log(e.toString());
          rethrow;
      }
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }

    if (userCreds.user == null) {
      throw NullUserException();
    }
    userInfo.uID = userCreds.user?.uid;
    try {
      _firestore.collection(_userCollectionString).doc(userInfo.uID).set({
        'firstName': userInfo.firstName,
        'lastName': userInfo.lastName,
        'email': email,
        'role': userInfo.role.toString(),
        'captures': jsonEncode(userInfo.captures),
        'trainees': jsonEncode(userInfo.trainees),
        'coaches': jsonEncode(userInfo.coaches),
      });
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  /// Signs in the user with the give [email] and [password].
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (_firebaseAuth.currentUser == null) {
        throw NullUserException();
      }

      DocumentSnapshot<Map<String, dynamic>> userInfoSnapshot = await _firestore
          .collection(_userCollectionString)
          .doc(_firebaseAuth.currentUser?.uid)
          .get();
      _currentSkatingUser = SkatingUser.fromFirestore(
          _firebaseAuth.currentUser?.uid, userInfoSnapshot);
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      _firebaseAuth.signOut();
      _currentSkatingUser = null;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  void delete() {
    if (_firebaseAuth.currentUser == null) {
      throw NullUserException();
    }
    String? uid = _firebaseAuth.currentUser?.uid;
    _firebaseAuth.currentUser?.delete();
    _firestore.collection(_userCollectionString).doc(uid).delete();
  }

  /// Put in a try catch. Throws an exception when there is an error during the operation
  Future<SkatingUser> getUserById(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userInfo =
          await _firestore.collection(_userCollectionString).doc(id).get();
      return SkatingUser.fromFirestore(id, userInfo);
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }
}
