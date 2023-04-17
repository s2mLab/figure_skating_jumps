import 'dart:io';
import 'package:figure_skating_jumps/enums/models/season.dart';
import 'package:figure_skating_jumps/models/firebase/capture.dart';
import 'package:figure_skating_jumps/models/local_db/local_capture.dart';
import 'package:figure_skating_jumps/models/firebase/jump.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/models/firebase/modification.dart';
import 'package:figure_skating_jumps/models/firebase/skating_user.dart';
import 'package:figure_skating_jumps/models/x_sens_dot_data.dart';
import 'package:figure_skating_jumps/services/external_storage_service.dart';
import 'package:figure_skating_jumps/services/local_db/local_captures_manager.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

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

  Future<Jump> createJump({required Jump jump, required currentCapture}) async {
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
      await _addNewJumpModificationToCapture(
          captureID: jump.captureID,
          jumpID: jump.uID!,
          currentCapture: currentCapture);
      return jump;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<Jump>> createJumps({required List<Jump> jumps}) async {
    try {
      List<String> jumpIds = [];
      List<Jump> firebaseJumps = [];
      for (Jump jump in jumps) {
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
        jumpIds.add(jumpInfo.id);
        jump.uID = jumpInfo.id;
        firebaseJumps.add(jump);
      }

      if (jumpIds.isNotEmpty) {
        _addMultipleJumpsToCapture(
            captureID: jumps.first.captureID, jumpIds: jumpIds);
      }
      return firebaseJumps;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> deleteJump({required Jump jump, required currentCapture}) async {
    try {
      await _addDeleteJumpModificationToCapture(
          captureID: jump.captureID,
          jumpID: jump.uID!,
          currentCapture: currentCapture);
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
      await _addUpdateJumpModificationToCapture(
          captureID: jump.captureID, updatedJump: jump);
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

  Future<Capture> saveCapture(
      {required String exportFileName,
      required List<XSensDotData> exportedData,
      required bool hasVideo,
      required String videoPath,
      required Season season}) async {
    String fullPath = await ExternalStorageService()
        .saveCaptureCsv(exportFileName, exportedData);
    await _saveCaptureCsv(fullPath: fullPath, fileName: exportFileName);

    // ExportedData is in us while we want it in ms
    int duration =
        ((exportedData.last.time - exportedData.first.time) / 1000).floor();
    Capture capture = Capture(exportFileName, _capturingSkatingUser!.uID!,
        duration, hasVideo, DateTime.now(), season, [], []);

    await _createCapture(capture: capture);
    await _linkCaptureToCurrentUser(capture: capture);

    if (hasVideo) {
      await LocalCapturesManager().saveCapture(
          LocalCapture(captureID: capture.uID!, videoPath: videoPath));
    }

    return capture;
  }

  Future<Capture> getCaptureByID({required String uID}) async {
    try {
      return Capture.fromFirestore(uID,
          await _firestore.collection(_captureCollectionString).doc(uID).get());
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

  Future<void> _addNewJumpModificationToCapture(
      {required String captureID,
      required String jumpID,
      required Capture currentCapture}) async {
    try {
      String action =
          "L'utilisateur ${UserClient().currentSkatingUser!.name} a ajouté le saut $jumpID à la capture $captureID.";
      currentCapture.modifications.add(Modification(action, DateTime.now()));
      await _addModificationToCapture(captureID: captureID, action: action);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> _addDeleteJumpModificationToCapture(
      {required String captureID,
      required String jumpID,
      required Capture currentCapture}) async {
    try {
      String action =
          "L'utilisateur ${UserClient().currentSkatingUser!.name} a supprimé le saut $jumpID de la capture $captureID.";
      currentCapture.modifications.add(Modification(action, DateTime.now()));
      await _addModificationToCapture(captureID: captureID, action: action);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> _addUpdateJumpModificationToCapture(
      {required String captureID, required Jump updatedJump}) async {
    try {
      Jump oldJump = await getJumpByID(uID: updatedJump.uID!);
      List<String> actions = _getJumpModificationActions(
          oldJump: oldJump, updatedJump: updatedJump);

      Capture capture = await getCaptureByID(uID: captureID);
      DateTime modificationTime = DateTime.now();
      for (String action in actions) {
        capture.modifications.add(Modification(action, modificationTime));
      }
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

  Future<void> _addModificationToCapture(
      {required String captureID, required String action}) async {
    try {
      Capture capture = await getCaptureByID(uID: captureID);
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

  List<String> _getJumpModificationActions(
      {required Jump oldJump, required Jump updatedJump}) {
    List<String> actions = [];
    String baseAction =
        "L'utilisateur ${UserClient().currentSkatingUser!.name} a changé la valeur du champ";
    String endAction =
        "du saut ${updatedJump.uID} de la capture ${updatedJump.captureID}";

    //Check which field as changed
    if (oldJump.comment != updatedJump.comment) {
      String commentAction =
          "$baseAction commentaire de ${oldJump.comment} à ${updatedJump.comment} $endAction";
      actions.add(commentAction);
    }

    if (oldJump.duration != updatedJump.duration) {
      String durationAction =
          "$baseAction durée de ${oldJump.duration} à ${updatedJump.duration} $endAction";
      actions.add(durationAction);
    }

    if (oldJump.score != updatedJump.score) {
      String scoreAction =
          "$baseAction score de ${oldJump.score} à ${updatedJump.score} $endAction";
      actions.add(scoreAction);
    }

    if (oldJump.time != updatedJump.time) {
      String timeAction =
          "$baseAction temps de ${oldJump.time} à ${updatedJump.time} $endAction";
      actions.add(timeAction);
    }

    if (oldJump.type != updatedJump.type) {
      String typeAction =
          "$baseAction type de ${oldJump.type} à ${updatedJump.type} $endAction";
      actions.add(typeAction);
    }

    if (oldJump.rotationDegrees != updatedJump.rotationDegrees) {
      String commentAction =
          "$baseAction tours de ${oldJump.rotationDegrees} à ${updatedJump.rotationDegrees} $endAction";
      actions.add(commentAction);
    }

    return actions;
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

  Future<void> _linkCaptureToCurrentUser({required Capture capture}) async {
    if (_capturingSkatingUser == null) return;
    await UserClient().linkCapture(
        userId: _capturingSkatingUser!.uID!, captureId: capture.uID!);
    _capturingSkatingUser?.capturesID.add(capture.uID!);
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

  Future<void> _addMultipleJumpsToCapture(
      {required String captureID, required List<String> jumpIds}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> captureInfo = await _firestore
          .collection(_captureCollectionString)
          .doc(captureID)
          .get();
      List<String> captureJumpsId =
          List<String>.from(captureInfo.get('jumps') as List);

      captureJumpsId.addAll(jumpIds);

      await _firestore
          .collection(_captureCollectionString)
          .doc(captureID)
          .update({"jumps": captureJumpsId});
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
