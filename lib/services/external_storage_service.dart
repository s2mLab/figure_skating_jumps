import 'dart:io';
import 'package:camera/camera.dart';
import 'package:figure_skating_jumps/models/x_sens_dot_data.dart';
import 'package:figure_skating_jumps/utils/csv_creator.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

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

  /// Saves the given video file in the default video directory.
  ///
  /// Parameters:
  /// - [f] : A [XFile] object representing the video file to be saved.
  ///
  /// Returns a [String] value containing the path of the saved video file upon completion.
  Future<String> saveVideo(XFile f) async {
    Directory directory = Directory(DirType.video.fullPath(
        dirName: DirType.video.defaults, relativePath: null.orAppFolder));

    await Directory('${directory.path}/$_videoDirPrefix')
        .create(recursive: true);

    String fileName = Uri.parse(f.path).pathSegments.last.trim();
    File file =
        await File(f.path).copy("${directory.path}/$_videoDirPrefix/$fileName");

    return Future<String>.value(file.path);
  }

  /// Saves the extracted data in a CSV file with the given file name.
  ///
  /// Parameters:
  /// - [fileName] : A [String] value representing the name of the CSV file to be saved.
  /// - [extractedData] : A [List] of [XSensDotData] objects representing the data to be saved in the CSV file.
  ///
  /// Returns a String value containing the path of the saved CSV file upon completion.
  Future<String> saveCaptureCsv(
      String fileName, List<XSensDotData> extractedData) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dirPath = '${directory.path}/csv';
    await Directory(dirPath).create(recursive: true);

    File file = File("$dirPath/$fileName");
    String csvContent = CsvCreator.createXSensDotCsv(extractedData);
    file.writeAsString(csvContent);

    return Future<String>.value(file.path);
  }
}
