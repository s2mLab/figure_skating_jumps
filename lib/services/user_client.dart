import 'dart:convert';

import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class UserClient {
  static final UserClient _userClient = UserClient._internal();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory UserClient() {
    return _userClient;
  }

  UserClient._internal();

  signUp(String email, String password, SkatingUser userInfo) {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCreds) {
          if(userCreds.user == null) {
              throw Exception('The created user is null');
          }
          userInfo.uID = userCreds.user?.uid;
          _firestore.collection('users').doc(userInfo.uID).set({
            'firstName': userInfo.firstName,
            'lastName': userInfo.lastName,
            'role': userInfo.role.toString(),
            'captures': jsonEncode(userInfo.captures),
            'trainees': jsonEncode(userInfo.trainees),
            'coaches': jsonEncode(userInfo.coaches),
          });
        })
        .catchError((e) {
          developer.log(e.toString());
          throw Exception(e);
        });
  }
}
