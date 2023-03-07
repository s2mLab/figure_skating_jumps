import 'dart:convert';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class CaptureClient {
  static final CaptureClient _userClient = CaptureClient._internal();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _userCollectionString = 'users';
  static const String _captureCollectionString = 'captures';
  static const String _jumpCollectionString = 'jumps';

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory CaptureClient() {
    return _userClient;
  }

  CaptureClient._internal();

  void addJump(Jump jump) async {
    _firestore.collection(_jumpCollectionString).add({
      "capture": jump.capture,
      "duration": jump.duration,
      "time": jump.time,
      "turns": jump.turns,
      "type": jump.type.toString()
    }).then((userInfo) {}, onError: (e) {
      developer.log(e.toString());
      throw Exception(e);
    });
  }
}