import 'dart:convert';

import 'package:figure_skating_jumps/enums/event_channel_names.dart';
import 'package:figure_skating_jumps/enums/recording/recorder_state.dart';
import 'package:figure_skating_jumps/enums/recording/recording_status.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_channel_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../enums/method_channel_names.dart';
import '../../models/xsens_dot_data.dart';

class XSensDotRecordingService {
  static final _recordingMethodChannel =
      MethodChannel(MethodChannelNames.recordingChannel.channelName);
  static final _recordingEventChannel =
      EventChannel(EventChannelNames.recordingChannel.channelName);
  static var _recorderState = RecorderState.idle;

  static final XSensDotRecordingService _xSensDotRecordingServiceService =
      XSensDotRecordingService._internal();

  static final List<XSensDotData> _exportedData = [];
  static String _exportFileName = "";

  final _recordingOutputRate = 120;

  factory XSensDotRecordingService() {
    _recordingEventChannel.receiveBroadcastStream().listen((event) async {
      await _handleRecordingEvents(event as String);
    });
    return _xSensDotRecordingServiceService;
  }

  XSensDotRecordingService._internal();

  static Future<void> _handleRecordingEvents(String event) async {
    var data = jsonDecode(event);
    var status =
        RecordingStatus.values.firstWhere((el) => el.status == data['status']);
    switch (status) {
      case RecordingStatus.setRate:
        await _handleSetRate();
        break;
      case RecordingStatus.enableRecordingNotificationDone:
        await _handleEnableRecordingNotificationDone(data['data']);
        break;
      case RecordingStatus.recordingStarted:
        _handleRecordingStarted();
        break;
      case RecordingStatus.recordingStopped:
        await _handleRecordingStopped();
        break;
      case RecordingStatus.getFlashInfoDone:
        await _handleGetFlashInfoDone(data['data']);
        break;
      case RecordingStatus.getFileInfoDone:
        await _handleGetFileInfoDone(data['data']);
        break;
      case RecordingStatus.extractingFile:
        _handleExtractingFile(data['data']);
        break;
      case RecordingStatus.extractFileDone:
        await _handleExtractFileDone();
        break;
      default:
        debugPrint("default");
        break;
    }
  }

  Future<void> startRecording() async {
    _exportedData.clear();
    _exportFileName = "";
    await XSensDotChannelService().setRate(_recordingOutputRate);
  }

  static Future<void> stopRecording() async {
    try {
      await _recordingMethodChannel.invokeMethod('stopRecording');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  static Future<void> _handleSetRate() async {
    await _recordingMethodChannel.invokeMethod('prepareRecording');
  }

  static Future<void> _handleEnableRecordingNotificationDone(String data) async {
    if(data == "true") {
      await _recordingMethodChannel.invokeMethod(
          'getFlashInfo', <String, dynamic>{
        'isExporting': _recorderState == RecorderState.exporting
      });
    } else {
      debugPrint("Recording notifications were not enabled");
    }

  }

  static void _handleRecordingStarted() {
    if (_recorderState == RecorderState.idle) {
      _recorderState = RecorderState.recording;
    }
  }

  static Future<void> _handleRecordingStopped() async {
    if (_recorderState == RecorderState.recording) {
      _recorderState = RecorderState.exporting;
      await _recordingMethodChannel.invokeMethod('prepareExtract');
    }
  }

  static Future<void> _handleGetFlashInfoDone(String? data) async {
    if (_recorderState == RecorderState.idle) {
      var canRecord = data == "true";
      if (canRecord) {
        try {
          await _recordingMethodChannel.invokeMethod('startRecording');
        } on PlatformException catch (e) {
          debugPrint(e.message!);
        }
      }
    } else if (_recorderState == RecorderState.exporting) {
      await _recordingMethodChannel.invokeMethod('getFileInfo');
    }
  }

  static Future<void> _handleGetFileInfoDone(String data) async {
    if (_recorderState == RecorderState.exporting) {
      _exportFileName = "${data.split(",")[1].split(": ")[1]}.csv";
      await _recordingMethodChannel.invokeMethod(
          'extractFile', <String, dynamic>{'fileInfo': data});
    }

  }

  static void _handleExtractingFile(String? data) {
    if (_recorderState == RecorderState.exporting) {
      if(data != null) {
        _exportedData.add(XSensDotData.fromEventChannel(data));
      }
    }
  }

  static Future<void> _handleExtractFileDone() async {
    if (_recorderState == RecorderState.exporting) {
      await CaptureClient().saveCapture(_exportFileName, _exportedData);
      debugPrint("Done");
      _recorderState = RecorderState.idle;
    }
  }

}
