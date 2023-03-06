import 'dart:convert';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class CaptureClient {
  static final CaptureClient _userClient = CaptureClient._internal();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _userCollectionString = 'users';

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory CaptureClient() {
    return _userClient;
  }

  CaptureClient._internal();

  void addJump(String captureId, ) {
    
  }
}