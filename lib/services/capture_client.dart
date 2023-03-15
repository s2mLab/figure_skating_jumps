import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class CaptureClient {
  static final CaptureClient _userClient = CaptureClient._internal();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _captureCollectionString = 'captures';

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory CaptureClient() {
    return _userClient;
  }

  CaptureClient._internal();

  Future<void> addJump({required Jump jump}) async {
    try {
      final collectionJump = await _firestore
          .collection(_captureCollectionString)
          .doc(jump.capture)
          .get();
      Capture capture =
          await Capture.createFromFireBase(jump.capture, collectionJump);
      capture.jumps.add(jump);
      await _firestore
          .collection(_captureCollectionString)
          .doc(jump.capture)
          .set({"jumps": capture.jumps}, SetOptions(merge: true));
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }
}
