import 'dart:io';

import 'package:camera/camera.dart';
import 'package:figure_skating_jumps/utils/csv_creator.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../models/xsens_dot_data.dart';

class ExternalStorageService {
  static final ExternalStorageService _externalStorageService =
      ExternalStorageService._internal();
  static const String _videoDirPrefix = "FigureSkatingJumpVideos";
  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory ExternalStorageService() {
    return _externalStorageService;
  }

  ExternalStorageService._internal();

  /// Saves a video from XFile [f] to external storage accessible to the user
  ///
  /// Returns the path of the file in external storage
  Future<String> saveVideo(XFile f) async {
    Directory directory = Directory(DirType.video.fullPath(
        dirName: DirType.video.defaults, relativePath: null.orAppFolder));

    await Directory('${directory.path}/$_videoDirPrefix').create(recursive: true);

    String fileName = Uri.parse(f.path).pathSegments.last.trim();
    File file =
        await File(f.path).copy("${directory.path}/$_videoDirPrefix/$fileName");

    return Future<String>.value(file.path);
  }

  Future<String> saveCaptureCsv(String fileName, List<XSensDotData> extractedData) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dirPath = '${directory.path}/csv';
    await Directory(dirPath).create(recursive: true);

    File file = File("$dirPath/$fileName");
    String csvContent = CsvCreator.createXSensDotCsv(extractedData);
    file.writeAsString(csvContent);

    return Future<String>.value(file.path);
  }

  
}
