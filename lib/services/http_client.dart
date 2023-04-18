import 'dart:convert';

import 'package:figure_skating_jumps/enums/models/jump_type.dart';
import 'package:figure_skating_jumps/models/firebase/jump.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HttpClient {
  static final HttpClient _httpClient = HttpClient._internal();
  static const String _serverAddress = "54.39.129.236:6666";
  static const String _addFileRoute = "file";
  static const String _analyzeRoute = "analyze";

  factory HttpClient() {
    return _httpClient;
  }

  HttpClient._internal();

  /// Uploads the given file content to a server using HTTP PUT method with the given file name.
  ///
  /// Parameters:
  /// - [fileName] : A [String] value representing the name of the file to be uploaded.
  /// - [fileContent] : A [String] value representing the content of the file to be uploaded.
  ///
  /// Returns a bool value representing the upload status, where true indicates
  /// a successful upload, and false indicates a failed upload.
  Future<bool> uploadFile(
      {required String fileName, required String fileContent}) async {
    Uri uri = Uri.http(_serverAddress, _addFileRoute, {"fileName": fileName});
    try {
      Response resp = await put(uri, body: fileContent);

      debugPrint(resp.statusCode.toString());

      return resp.statusCode == 200;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Analyzes a capture file and to try and find jumps.
  ///
  /// Parameters:
  /// - [fileName] : The name of the capture file to analyze.
  /// - [captureID] : A unique ID to associate with the capture file.
  ///
  /// Returns a [List] of [Jump] objects representing the detected jumps in the
  /// capture file. If an error occurs, returns null.
  Future<List<Jump>?> analyze(
      {required String fileName, required String captureID}) async {
    Uri uri = Uri.http(_serverAddress, _analyzeRoute);
    Map<String, String> content = {"fileName": fileName};

    try{
      Response resp = await post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(content));

      debugPrint(resp.statusCode.toString());

      if (resp.statusCode != 200) return null;
      List<Jump> jumps = [];
      for (var jump in jsonDecode(resp.body)) {
        jumps.add(Jump(
            ((jump['start'] * 1000) as double).round(),
            ((jump['duration'] * 1000) as double).round(),
            false,
            JumpType.unknown,
            "",
            0,
            captureID,
            jump['timeToMax'],
            jump['maxRotSpeed'],
            jump['numRot']));
      }

      return jumps;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
