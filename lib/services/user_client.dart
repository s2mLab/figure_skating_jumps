import 'dart:convert';
import 'package:figure_skating_jumps/exceptions/conflict_exception.dart';
import 'package:figure_skating_jumps/exceptions/invalid-email-exception.dart';
import 'package:figure_skating_jumps/exceptions/null-user-exception.dart';
import 'package:figure_skating_jumps/exceptions/weak-password-exception.dart';
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
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }

    if (userCreds.user == null) {
      throw Exception('The created user is null');
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
  ///
  /// Can throw a **[NullUserException]** when the created user is null
  void signIn(String email, String password) {
    _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCreds) {:
      if (userCreds.user == null) {
        throw NullUserException();
      }
      _firestore
          .collection(_userCollectionString)
          .doc(userCreds.user?.uid)
          .get()
          .then((userInfo) => _currentSkatingUser =
              SkatingUser.fromFirestore(userCreds.user?.uid, userInfo));
    }).catchError((e) {
      developer.log(e.toString());
      throw Exception(e);
    });
  }

  void signOut() {
    _currentSkatingUser = null;
    _firebaseAuth.signOut();
  }

  void delete() {
    if (_firebaseAuth.currentUser == null) {
      throw Exception("No user signed in.");
    }
    String? uid = _firebaseAuth.currentUser?.uid;
    _firebaseAuth.currentUser?.delete();
    _firestore.collection(_userCollectionString).doc(uid).delete();
  }

  void getUserById(String id) {
    _firestore.collection(_userCollectionString).doc(id).get().then()
  }
}
