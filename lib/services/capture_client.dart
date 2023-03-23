import 'dart:io';

import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../models/xsens_dot_data.dart';
import 'external_storage_service.dart';

class CaptureClient {
  static final CaptureClient _captureClient = CaptureClient._internal();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Reference appBucketRef = FirebaseStorage.instance.ref();

  static const String _captureCollectionString = 'captures';
  String _capturingSkatingUserUid = "";

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory CaptureClient() {
    return _captureClient;
  }

  set capturingSkatingUserUid(String skatingUserUid) {
    if (skatingUserUid.isNotEmpty) _capturingSkatingUserUid = skatingUserUid;
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

  Future<void> saveCapture(String exportFileName, List<XSensDotData> exportedData) async {
    String fullPath = await ExternalStorageService().saveCaptureCsv(exportFileName, exportedData);
    await _saveCaptureCsv(fullPath, exportFileName);
    var duration = exportedData.last.time - exportedData.first.time;
    var capture = Capture(exportFileName, _capturingSkatingUserUid, duration, DateTime.now(), []);
    await _addCapture(capture: capture);
  }

  Future<void> _addCapture({required Capture capture}) async {

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
}
