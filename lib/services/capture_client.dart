import 'dart:io';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/models/modification.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../enums/season.dart';
import '../models/xsens_dot_data.dart';
import 'external_storage_service.dart';
import '../models/skating_user.dart';

class CaptureClient {
  static final CaptureClient _captureClient = CaptureClient._internal();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Reference appBucketRef = FirebaseStorage.instance.ref();

  static const String _captureCollectionString = 'captures';
  static const String _jumpsCollectionString = 'jumps';
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

  Future<void> createJump({required Jump jump}) async {
    try {
      DocumentReference<Map<String, dynamic>> jumpInfo =
          await _firestore.collection(_jumpsCollectionString).add({
        'capture': jump.captureID,
        'comment': jump.comment,
        'duration': jump.duration,
        'isCustom': jump.isCustom,
        'score': jump.score,
        'time': jump.time,
        'type': jump.type.toString(),
        'durationToMaxSpeed': jump.durationToMaxSpeed,
        'maxSpeed': jump.maxRotationSpeed,
        'rotation': jump.rotationDegrees,
      });
      jump.uID = jumpInfo.id;
      _modifyCaptureJumpList(
          captureID: jump.captureID, jumpID: jumpInfo.id, linkJump: true);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> deleteJump({required Jump jump}) async {
    try {
      await _firestore
          .collection(_jumpsCollectionString)
          .doc(jump.uID)
          .delete();
      _modifyCaptureJumpList(
          captureID: jump.captureID, jumpID: jump.uID!, linkJump: false);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateJump({required Jump jump}) async {
    try {
      await _firestore.collection(_jumpsCollectionString).doc(jump.uID!).set({
        'capture': jump.captureID,
        'comment': jump.comment,
        'duration': jump.duration,
        'isCustom': jump.isCustom,
        'score': jump.score,
        'time': jump.time,
        'type': jump.type.toString(),
        'durationToMaxSpeed': jump.durationToMaxSpeed,
        'maxSpeed': jump.maxRotationSpeed,
        'rotation': jump.rotationDegrees,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> saveCapture(
      {required String exportFileName,
      required List<XSensDotData> exportedData,
      required bool hasVideo,
      required Season season}) async {
    String fullPath = await ExternalStorageService()
        .saveCaptureCsv(exportFileName, exportedData);
    await _saveCaptureCsv(fullPath: fullPath, fileName: exportFileName);
    int duration = exportedData.last.time - exportedData.first.time;
    Capture capture = Capture(exportFileName, _capturingSkatingUser!.uID!,
        duration, hasVideo, DateTime.now(), season, [], []);
    await _createCapture(capture: capture);
  }

  Future<Capture> getCaptureByID({required String uID}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> captureInfo =
          await _firestore.collection(_captureCollectionString).doc(uID).get();
      return await Capture.createFromFirebase(uID, captureInfo);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Jump> getJumpByID({required String uID}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> jumpInfo =
          await _firestore.collection(_jumpsCollectionString).doc(uID).get();
      return Jump.fromFirestore(uID, jumpInfo);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> addModificationToCapture(
      {required String captureID,
      required String field,
      required String oldValue,
      required String value}) async {
    try {
      Capture capture = await getCaptureByID(uID: captureID);
      String action =
          "L'utilisateur ${UserClient().currentSkatingUser!.name} a changé la valeur du champ $field de $oldValue pour $value.";
      capture.modifications.add(Modification(action, DateTime.now()));
      await _firestore
          .collection(_captureCollectionString)
          .doc(captureID)
          .update({
        'modifications': capture.modsAsMap,
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> _saveCaptureCsv(
      {required String fullPath, required String fileName}) async {
    Reference fileRef = appBucketRef.child(fileName);
    File captureCsvFile = File(fullPath);
    await captureCsvFile.absolute.exists();

    try {
      await fileRef.putFile(captureCsvFile);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _createCapture({required Capture capture}) async {
    try {
      DocumentReference<Map<String, dynamic>> captureInfo =
          await _firestore.collection(_captureCollectionString).add({
        'date': capture.date,
        'duration': capture.duration,
        'file': capture.fileName,
        'hasVideo': capture.hasVideo,
        'season': capture.season.toString(),
        'jumps': capture.jumpsID,
        'user': capture.userID,
        'modifications': capture.modifications
      });
      capture.uID = captureInfo.id;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> _modifyCaptureJumpList(
      {required String captureID,
      required String jumpID,
      required bool linkJump}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> captureInfo = await _firestore
          .collection(_captureCollectionString)
          .doc(captureID)
          .get();
      List<String> jumpsID =
          List<String>.from(captureInfo.get('jumps') as List);

      if (linkJump) {
        jumpsID.add(jumpID);
      } else {
        jumpsID.remove(jumpID);
      }

      await _firestore
          .collection(_captureCollectionString)
          .doc(captureID)
          .update({"jumps": jumpsID});
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
