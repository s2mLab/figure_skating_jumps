import 'dart:convert';

import 'package:figure_skating_jumps/enums/event_channel_names.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../enums/method_channel_names.dart';

class XSensDotRecordingService {
  static final _recordingMethodChannel = MethodChannel(MethodChannelNames.recordingChannel.channelName);
  static final _recordingEventChannel = EventChannel(EventChannelNames.recordingChannel.channelName);

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
  }

  static Future<void> startRecording() async {
    try {
      await _recordingMethodChannel.invokeMethod('startRecording');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  static Future<void> stopRecording() async {
    try {
      await _recordingMethodChannel.invokeMethod('stopRecording');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  void noop() {
    debugPrint("noop");
  }
}