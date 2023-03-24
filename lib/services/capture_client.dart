import 'dart:io';
import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../models/xsens_dot_data.dart';
import 'external_storage_service.dart';
import '../models/skating_user.dart';

class CaptureClient {
  static final CaptureClient _captureClient = CaptureClient._internal();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Reference appBucketRef = FirebaseStorage.instance.ref();

  static const String _captureCollectionString = 'captures';
  SkatingUser? _capturingSkatingUser;

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory CaptureClient() {
    return _captureClient;
  }

  set capturingSkatingUser(SkatingUser skatingUser) {
    _capturingSkatingUser = skatingUser;
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
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> saveCapture(String exportFileName, List<XSensDotData> exportedData) async {
    String fullPath = await ExternalStorageService().saveCaptureCsv(exportFileName, exportedData);
    await _saveCaptureCsv(fullPath, exportFileName);
    var duration = exportedData.last.time - exportedData.first.time;
    var capture = Capture(exportFileName, _capturingSkatingUser!.uID!, duration, DateTime.now(), []);
    await _addCapture(capture: capture);
  }

  Future<void> _addCapture({required Capture capture}) async {
    try {
      await _firestore
          .collection(_captureCollectionString).add({
          'date': capture.date,
          'duration': capture.duration,
          'file': capture.fileName,
          'jumps': capture.jumpsID,
          'user': capture.userID
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> _saveCaptureCsv(String fullPath, String fileName) async {
    var fileRef = appBucketRef.child(fileName);
    var captureCsvFile = File(fullPath);
    await captureCsvFile.absolute.exists();

    try {
      await fileRef.putFile(captureCsvFile);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Map<String, List<Capture>>> loadCapturesData(SkatingUser skater) async {
    List<Capture> captures = [];
    for (String captureID in skater.captures) {
      captures.add(await Capture.createFromFireBase(
          captureID,
          await _firestore
              .collection(_captureCollectionString)
              .doc(captureID)
              .get()));
    }
    return groupBy(captures, (obj) => obj.date.toString().substring(0, 10));
  }
}
