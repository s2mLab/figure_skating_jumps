import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class CaptureClient {
  static final CaptureClient _userClient = CaptureClient._internal();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _jumpCollectionString = 'jumps';
  static const String _captureCollectionString = 'captures';

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory CaptureClient() {
    return _userClient;
  }

  CaptureClient._internal();

  Future<void> addJump({required Jump jump}) async {
    try {
      Capture capture = await Capture.create(
          jump.capture,
          await _firestore
              .collection(_captureCollectionString)
              .doc(jump.capture)
              .get());
      DocumentReference<Map<String, dynamic>> temp =
          await _firestore.collection(_jumpCollectionString).add({
        "capture": jump.capture,
        "duration": jump.duration,
        "time": jump.time,
        "turns": jump.turns,
        "type": jump.type.toString()
      });
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
