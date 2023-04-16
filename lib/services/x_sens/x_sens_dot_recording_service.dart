import 'dart:async';
import 'dart:convert';
import 'package:figure_skating_jumps/enums/event_channel_names.dart';
import 'package:figure_skating_jumps/enums/method_channel_names.dart';
import 'package:figure_skating_jumps/enums/recording/recorder_state.dart';
import 'package:figure_skating_jumps/enums/recording/recording_status.dart';
import 'package:figure_skating_jumps/enums/season.dart';
import 'package:figure_skating_jumps/interfaces/i_observable.dart';
import 'package:figure_skating_jumps/interfaces/i_recorder_state_subscriber.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/models/export_status_event.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:figure_skating_jumps/models/xsens_dot_data.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';
import 'package:figure_skating_jumps/services/http_client.dart';
import 'package:figure_skating_jumps/utils/csv_creator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class XSensDotRecordingService
    implements IObservable<IRecorderSubscriber, RecorderState> {
  static final _recordingMethodChannel =
      MethodChannel(MethodChannelNames.recordingChannel.channelName);
  static final _recordingEventChannel =
      EventChannel(EventChannelNames.recordingChannel.channelName);
  static var _recorderState = RecorderState.idle;
  final List<IRecorderSubscriber> _subscribers = [];

  static final XSensDotRecordingService _xSensDotRecordingServiceService =
      XSensDotRecordingService._internal();

  static final List<XSensDotData> _exportedData = [];
  static String _exportFileName = "";

  static bool _currentRecordingHasVideo = false;
  static String _currentRecordingVideoPath = "";

  static Season season = Season.preparation;
  static Capture? _currentCapture;
  static const int _recordingOutputRate = 120;
  static const int _estimatedExportRate = 30;
  static late DateTime _startTime;
  static late int _totalRecordingData;
  static final StreamController<ExportStatusEvent>
      _exportStatusStreamController = StreamController<ExportStatusEvent>();
  static final Stream<ExportStatusEvent> _exportStream =
      _exportStatusStreamController.stream.asBroadcastStream();

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
      case RecordingStatus.eraseMemoryDone:
        _handleEraseMemoryDone();
        break;
      default:
        debugPrint("default");
        break;
    }
  }

  Future<void> startRecording() async {
    _exportedData.clear();
    _exportFileName = "";
    _currentRecordingHasVideo = false;
    _currentRecordingVideoPath = "";
    _totalRecordingData = 0;
    _changeState(RecorderState.preparing);
    await _setRate();
  }

  RecorderState get recorderState {
    return _recorderState;
  }

  Capture get currentCapture {
    return _currentCapture!;
  }

  Stream<ExportStatusEvent> get exportStatusStream {
    return _exportStream;
  }

  Future<void> stopRecording(bool hasVideo, String videoPath) async {
    _currentRecordingHasVideo = hasVideo;
    _currentRecordingVideoPath = videoPath;
    try {
      await _recordingMethodChannel.invokeMethod('stopRecording');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  Future<void> eraseMemory() async {
    if (_recorderState == RecorderState.full) {
      _changeState(RecorderState.erasing);
      await _recordingMethodChannel.invokeMethod('prepareExtract');
    }
  }

  static Future<void> _setRate() async {
    try {
      await _recordingMethodChannel.invokeMethod(
          'setRate', <String, dynamic>{'rate': _recordingOutputRate});
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  static Future<void> _handleSetRate() async {
    await _recordingMethodChannel.invokeMethod('prepareRecording');
  }

  static Future<void> _handleEnableRecordingNotificationDone(
      String data) async {
    if (data == "true") {
      await _recordingMethodChannel
          .invokeMethod('getFlashInfo', <String, dynamic>{
        'isManagingFiles': _recorderState == RecorderState.exporting ||
            _recorderState == RecorderState.erasing
      });
    } else {
      debugPrint("Recording notifications were not enabled");
    }
  }

  static void _handleRecordingStarted() {
    if (_recorderState == RecorderState.preparing) {
      _startTime = DateTime.now();
      _changeState(RecorderState.recording);
    }
  }

  static Future<void> _handleRecordingStopped() async {
    if (_recorderState == RecorderState.recording) {
      int recordingDuration = DateTime.now().millisecondsSinceEpoch -
          _startTime.millisecondsSinceEpoch;
      _totalRecordingData =
          (_recordingOutputRate * recordingDuration / 1000.0).ceil().toInt();
      _changeState(RecorderState.exporting);
      await _recordingMethodChannel.invokeMethod('prepareExtract');
    }
  }

  static Future<void> _handleGetFlashInfoDone(String? data) async {
    switch (_recorderState) {
      case RecorderState.preparing:
        bool canRecord = data == "true";
        if (!canRecord) {
          _changeState(RecorderState.full);
          return;
        }
        try {
          await _recordingMethodChannel.invokeMethod('startRecording');
        } on PlatformException catch (e) {
          debugPrint(e.message!);
        }
        break;
      case RecorderState.exporting:
        await _recordingMethodChannel.invokeMethod('getFileInfo');
        break;
      case RecorderState.erasing:
        await _recordingMethodChannel.invokeMethod('eraseMemory');
        break;
      default:
        break;
    }
  }

  static Future<void> _handleGetFileInfoDone(String data) async {
    if (_recorderState == RecorderState.exporting) {
      _exportFileName = "${data.split(",")[1].split(": ")[1]}.csv";
      await _recordingMethodChannel
          .invokeMethod('extractFile', <String, dynamic>{'fileInfo': data});
    }
  }

  static void _handleExtractingFile(String? data) {
    if (_recorderState == RecorderState.exporting) {
      if (data != null) {
        _exportedData.add(XSensDotData.fromEventChannel(data));
        double exportPct =
            _exportedData.length.toDouble() / _totalRecordingData.toDouble();
        int remainingSeconds = ((_totalRecordingData - _exportedData.length) /
                _estimatedExportRate)
            .ceil()
            .toInt();
        Duration timeRemaining = Duration(seconds: remainingSeconds);
        _exportStatusStreamController.add(ExportStatusEvent(
            exportPct: exportPct, timeRemaining: timeRemaining));
      }
    }
  }

  static Future<void> _handleExtractFileDone() async {
    if (_recorderState == RecorderState.exporting) {
      _currentCapture = await CaptureClient().saveCapture(
          exportFileName: _exportFileName,
          exportedData: _exportedData,
          hasVideo: _currentRecordingHasVideo,
          videoPath: _currentRecordingVideoPath,
          season: season);
      debugPrint("Done");
      _changeState(RecorderState.analyzing);
      await _analyzeData();
    }
  }

  static Future<void> _analyzeData() async {
    String content = CsvCreator.createXSensDotCsv(_exportedData);
    bool success = await HttpClient()
        .uploadFile(fileName: _exportFileName, fileContent: content);
    if (success) {
      List<Jump>? jumps = await HttpClient()
          .analyze(fileName: _exportFileName, captureID: _currentCapture!.uID!);

      List<Jump> analyzedJumps =
          await CaptureClient().createJumps(jumps: jumps!);
      _currentCapture?.jumpsID.addAll(analyzedJumps.map((jump) => jump.uID!));
    }
    _changeState(RecorderState.idle);
  }

  static void _handleEraseMemoryDone() async {
    _changeState(RecorderState.idle);
  }

  static void _changeState(RecorderState state) {
    _recorderState = state;
    XSensDotRecordingService().notifySubscribers(state);
  }

  @override
  void notifySubscribers(RecorderState state) {
    for (IRecorderSubscriber sub in _subscribers) {
      sub.onStateChange(state);
    }
  }

  @override
  RecorderState subscribe(IRecorderSubscriber subscriber) {
    _subscribers.add(subscriber);
    return _recorderState;
  }

  @override
  void unsubscribe(IRecorderSubscriber subscriber) {
    _subscribers.remove(subscriber);
  }
}
