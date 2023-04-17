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

  /// Creates a new Jump and saves it to Firestore.
  ///
  /// Throws a [FirebaseException] if there is an error saving the jump to Firestore.
  ///
  /// Parameters:
  /// - [jump] : The [Jump] to create.
  /// - [capture] : The [Capture] associated with the jump.
  ///
  /// Returns the newly created [Jump] object when the jump is successfully saved to Firestore.
  /// The [Jump] is returned with its uID from Firestore.
  Future<Jump> createJump(
      {required Jump jump, required Capture capture}) async {
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
          capture: capture,
          jumpID: jump.uID!);
      return jump;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// Creates and saves all the jumps passed in the list to Firestore.
  ///
  /// Throws a [FirebaseException] if there is an error during the save to Firestore.
  ///
  /// Parameters:
  /// - [jumps] : The list of [Jump] to create.
  ///
  /// Returns a list of [Jump] objects. Each of these jumps has its uID from Firestore.
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

  /// Deletes a [Jump] from the Firestore database.
  /// Also updates the capture's jump list and creates a modification to track
  /// the deletion.
  ///
  /// Throws a [FirebaseException] if there is an error deleting the document.
  /// Throws an [ArgumentError] if [jump.uID] is null.
  ///
  /// Parameters:
  /// - [jump] : The [Jump] to delete.
  /// - [capture] : The [Capture] object corresponding to the capture that
  ///   contains the jump.
  ///
  /// Returns void.
  Future<void> deleteJump(
      {required Jump jump, required Capture capture}) async {
    try {
      await _addDeleteJumpModificationToCapture(
          capture: capture,
          jumpID: jump.uID!);
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

  /// Updates an existing jump document in Firestore with the provided jump object.
  ///
  /// Throws a [FirebaseException] if there was an error updating the document.
  ///
  /// Parameters:
  /// - [jump] : The [Jump] object with the new values. The uID must be set to complete the update.
  /// - [capture] : The [Capture] associated to the jump.
  ///
  /// Returns void.
  Future<void> updateJump(
      {required Jump jump, required Capture capture}) async {
    try {
      await _addUpdateJumpModificationToCapture(
          capture: capture,
          updatedJump: jump);
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

  /// Saves XSens data locally and to Firebase. It creates a capture associated
  /// to the data. If there is video, it'll save it locally.
  ///
  /// Throws a [FirebaseException] if there is an error while accessing the Firestore database.
  ///
  /// Parameters:
  /// - [exportFileName] : A [String] representing the export file name.
  /// - [exportedData] : A [List] of [XSensDotData] representing the exported data to be saved.
  /// - [hasVideo] : A [bool] indicating whether the capture has a video.
  /// - [videoPath] : A [String] representing the path to the video file.
  /// - [season] : A [Season] representing the season the capture was made in.
  ///
  /// Returns the saved [Capture] object.
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

  /// Retrieves a Capture object from Firestore by the provided uID.
  ///
  /// Throws a [FirebaseException] if there is an error retrieving the Capture object from Firestore.
  ///
  /// Parameters:
  /// - [uID] : The unique identifier of the [Capture] object to be retrieved.
  ///
  /// Returns the retrieved [Capture] object if successful.
  Future<Capture> getCaptureByID({required String uID}) async {
    try {
      return Capture.fromFirestore(uID,
          await _firestore.collection(_captureCollectionString).doc(uID).get());
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// Retrieves a [Jump] object by its ID from Firestore.
  ///
  /// Throws a [FirebaseException] if an error occurs while retrieving the Capture object from Firestore.
  ///
  /// Parameters:
  /// - [uID] : The ID of the [Jump] to retrieve.
  ///
  /// Returns the wanted [Jump] object.
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

  /// Adds a new [Jump] modification to a [Capture] in Firestore.
  ///
  /// Throws a [FirebaseException] if an error occurs.
  ///
  /// Parameters:
  /// - [capture] : The current [Capture] object to be updated.
  /// - [jumpID] : The ID of the [Jump] to add to the Capture.
  ///
  /// Returns void.
  Future<void> _addNewJumpModificationToCapture(
      {required Capture capture,
      required String jumpID}) async {
    try {
      String action =
          "L'utilisateur ${UserClient().currentSkatingUser!.name} a ajouté le saut $jumpID à la capture ${capture.uID!}.";
      await _addModificationToCapture(
          capture: capture, action: action);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// Adds a [Jump] deleted modification to a [Capture] object.
  ///
  /// Throws a [FirebaseException] if an error occurs.
  ///
  /// Parameters:
  /// - [capture] : The current [Capture] object being modified.
  /// - [jumpID] : The ID of the [Jump] being deleted
  ///
  /// Returns void.
  Future<void> _addDeleteJumpModificationToCapture(
      {required Capture capture,
      required String jumpID}) async {
    try {
      String action =
          "L'utilisateur ${UserClient().currentSkatingUser!.name} a supprimé le saut $jumpID de la capture ${capture.uID!}.";
      await _addModificationToCapture(
          capture: capture, action: action);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// Adds a [Jump] updated modification to a Capture object.
  ///
  /// Throws a [FirebaseException] if an error occurs.
  ///
  /// Parameters:
  /// - [capture] : The current [Capture] object to be modified.
  /// - [updatedJump] : The updated [Jump] object.
  ///
  /// Returns void.
  Future<void> _addUpdateJumpModificationToCapture(
      {required Capture capture,
      required Jump updatedJump}) async {
    try {
      Jump oldJump = await getJumpByID(uID: updatedJump.uID!);
      List<String> actions = _getJumpModificationActions(
          oldJump: oldJump, updatedJump: updatedJump);

      DateTime modificationTime = DateTime.now();
      for (String action in actions) {
        capture.modifications
            .add(Modification(action, modificationTime));
      }
      await _firestore
          .collection(_captureCollectionString)
          .doc(capture.uID!)
          .update({
        'modifications': capture.modsAsMap,
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// Adds a modification to a Capture object and updates the corresponding Firestore document.
  ///
  /// Throws a [FirebaseException] if an error occurs.
  ///
  /// Parameters:
  /// - [capture] : The [Capture] object to add the modification to.
  /// - [action] : The action as a [String] to add as a modification to the [Capture].
  ///
  /// Returns void.
  Future<void> _addModificationToCapture(
      {required Capture capture, required String action}) async {
    try {
      capture.modifications.add(Modification(action, DateTime.now()));
      await _firestore
          .collection(_captureCollectionString)
          .doc(capture.uID!)
          .update({
        'modifications': capture.modsAsMap,
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// Returns a list of strings describing the modifications made to a [Jump] object.
  ///
  /// Parameters:
  /// - [oldJump] : The original [Jump] object.
  /// - [updatedJump] : The updated [Jump] object.
  ///
  /// Returns a list of strings describing the modifications made to the Jump object.
  /// The strings are in the following format: "L'utilisateur {username} a changé la valeur du champ {field} du saut {jumpID} de la capture {captureID} de {oldValue} à {updatedValue}"
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

  /// Saves a CSV file of a capture to Firebase Storage
  ///
  /// Throws a [FirebaseException] if an error occurs when saving the file
  ///
  /// Parameters:
  /// - [fullPath] : the full path to the CSV file to be saved
  /// - [fileName] : the name of the file to be saved
  ///
  /// Returns void.
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

  /// Creates a new capture in Firestore and returns its unique ID.
  ///
  /// Throws a [FirebaseException] if the creation fails.
  ///
  /// Parameters:
  /// - [capture] : The [Capture] object to be saved in Firestore.
  ///
  /// Returns the unique ID of the created capture as a [String].
  Future<String> _createCapture({required Capture capture}) async {
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
      return captureInfo.id;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// Links the given capture to the currently logged-in user.
  /// Does nothing if there is no user currently logged in.
  ///
  /// Parameters:
  /// - [capture] : The [Capture] to link to the current user.
  ///
  /// Returns void.
  Future<void> _linkCaptureToCurrentUser({required Capture capture}) async {
    if (_capturingSkatingUser == null) return;
    await UserClient().linkCapture(
        userId: _capturingSkatingUser!.uID!, captureId: capture.uID!);
    _capturingSkatingUser?.capturesID.add(capture.uID!);
  }

  /// Modifies the list of jumps linked to a capture by adding or removing a jump.
  ///
  /// Throws a [FirebaseException] if an error occurs while accessing the Firestore database.
  ///
  /// Parameters:
  /// - [captureID] : A [String] representing the ID of the capture.
  /// - [jumpID] : A [String] representing the ID of the jump to be linked/removed.
  /// - [linkJump] : A [bool] indicating whether to link or remove the jump from the list.
  ///
  /// Returns a [Future] that completes with no result when the operation is complete.
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

  /// Adds multiple jump IDs to a capture.
  ///
  /// Throws a [FirebaseException] if an error occurs during the Firestore operation.
  ///
  /// Parameters:
  /// - [captureID] : The ID of the [Capture] to which jumps will be added.
  /// - [jumpIds] : The IDs of the jumps to add to the [Capture].
  ///
  /// Returns void.
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
