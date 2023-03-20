import 'dart:convert';

import 'package:figure_skating_jumps/enums/event_channel_names.dart';
import 'package:figure_skating_jumps/enums/recording/recorder_state.dart';
import 'package:figure_skating_jumps/enums/recording/recording_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../enums/method_channel_names.dart';

class XSensDotRecordingService {
  static final _recordingMethodChannel =
      MethodChannel(MethodChannelNames.recordingChannel.channelName);
  static final _recordingEventChannel =
      EventChannel(EventChannelNames.recordingChannel.channelName);
  static var _recorderState = RecorderState.idle;

  static final XSensDotRecordingService _xSensDotRecordingServiceService =
      XSensDotRecordingService._internal();

  factory XSensDotRecordingService() {
    _recordingEventChannel.receiveBroadcastStream().listen((event) async {
      await _handleRecordingEvents(event as String);
    });
    return _xSensDotRecordingServiceService;
  }

  XSensDotRecordingService._internal();

  static Future<void> _handleRecordingEvents(String event) async {
    debugPrint(event);
    var data = jsonDecode(event);
    var status =
        RecordingStatus.values.firstWhere((el) => el.status == data['status']);
    switch (status) {
      case RecordingStatus.enableRecordingNotificationDone:
        debugPrint(data['data']);
        await _recordingMethodChannel.invokeMethod(
            'getFlashInfo', <String, dynamic>{
          'isExporting': _recorderState == RecorderState.exporting
        });
        break;
      case RecordingStatus.recordingStarted:
        if (_recorderState == RecorderState.idle) {
          _recorderState = RecorderState.recording;
        }
        break;
      case RecordingStatus.recordingStopped:
        if (_recorderState == RecorderState.recording) {
          _recorderState = RecorderState.exporting;
          await _recordingMethodChannel.invokeMethod('prepareExtract');
        }
        break;
      case RecordingStatus.getFlashInfoDone:
        debugPrint("FlashInfo");
        if (_recorderState == RecorderState.idle) {
          var canRecord = data['data'] == "true";
          if (canRecord) {
            try {
              await _recordingMethodChannel.invokeMethod('startRecording');
            } on PlatformException catch (e) {
              debugPrint(e.message!);
            }
          }
        }
        if (_recorderState == RecorderState.exporting) {
          await _recordingMethodChannel.invokeMethod('getFileInfo');
        }
        break;
      case RecordingStatus.getFileInfoDone:
        if (_recorderState == RecorderState.exporting) {
          await _recordingMethodChannel.invokeMethod(
              'extractFile', <String, dynamic>{'fileInfo': data['data']});
        }
        break;
      case RecordingStatus.extractingFile:
        if (_recorderState == RecorderState.exporting) {
          debugPrint(event);
        }
        break;
      case RecordingStatus.extractFileDone:
        if (_recorderState == RecorderState.exporting) {
          debugPrint("Done");
          _recorderState = RecorderState.idle;
        }
        break;
      default:
        debugPrint("default");
        break;
    }
  }

  static Future<void> startRecording() async {
    await _recordingMethodChannel.invokeMethod('prepareRecording');
  }

  static Future<void> stopRecording() async {
    try {
      await _recordingMethodChannel.invokeMethod('stopRecording');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  //TODO remove when the class is integrated in the UI/with the capture save
  void noop() {
    debugPrint("noop");
  }
}
