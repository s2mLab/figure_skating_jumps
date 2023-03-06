import 'dart:convert';
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

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (_firebaseAuth.currentUser == null) {
        throw Exception('The signed in user is null');
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
}
