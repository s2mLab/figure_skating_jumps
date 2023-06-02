import 'dart:async';
import 'dart:convert';
import 'package:figure_skating_jumps/enums/event_channel_names.dart';
import 'package:figure_skating_jumps/enums/method_channel_names.dart';
import 'package:figure_skating_jumps/enums/x_sens/recording/recorder_state.dart';
import 'package:figure_skating_jumps/enums/x_sens/recording/recording_status.dart';
import 'package:figure_skating_jumps/enums/models/season.dart';
import 'package:figure_skating_jumps/interfaces/i_observable.dart';
import 'package:figure_skating_jumps/interfaces/i_recorder_state_subscriber.dart';
import 'package:figure_skating_jumps/models/firebase/capture.dart';
import 'package:figure_skating_jumps/models/export_status_event.dart';
import 'package:figure_skating_jumps/models/firebase/jump.dart';
import 'package:figure_skating_jumps/models/x_sens_dot_data.dart';
import 'package:figure_skating_jumps/services/firebase/capture_client.dart';
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
  static Timer? _timeoutTimer;
  static const Duration _timeoutDuration = Duration(seconds: 30);

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

  /// Stops the recording.
  ///
  /// Throws a [PlatformException] if the platform API call fails.
  ///
  /// Parameters:
  /// - [hasVideo] : a [bool] value indicating whether the recording has video or not.
  /// - [videoPath] : a [String] representing the file path to the video.
  ///
  /// Returns void.
  Future<void> stopRecording(bool hasVideo, String videoPath) async {
    _currentRecordingHasVideo = hasVideo;
    _currentRecordingVideoPath = videoPath;
    try {
      await _recordingMethodChannel.invokeMethod('stopRecording');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  /// Erases the memory of the recorder if it's full.
  ///
  /// Returns void.
  Future<void> eraseMemory() async {
    if (_recorderState == RecorderState.full) {
      _changeState(RecorderState.erasing);
      await _recordingMethodChannel.invokeMethod('prepareExtract');
    }
  }

  /// Changes the state to idle after an error.
  ///
  /// Returns void.
  void acknowledgeError() {
    _changeState(RecorderState.idle);
  }

  /// Sets the recording rate.
  ///
  /// Throws a [PlatformException] if a platform-specific error occurs during the
  /// invocation of the recording method channel.
  ///
  /// Returns void.
  static Future<void> _setRate() async {
    _resetTimer();
    try {
      await _recordingMethodChannel.invokeMethod(
          'setRate', <String, dynamic>{'rate': _recordingOutputRate});
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  /// Resets the timer and prepares for recording.
  ///
  /// Returns void.
  static Future<void> _handleSetRate() async {
    _resetTimer();
    await _recordingMethodChannel.invokeMethod('prepareRecording');
  }

  /// Handles the enable recording notification by calling the method or logging
  /// a message.
  ///
  /// Parameters:
  /// - [data] : The boolean completion status of the process as a string.
  ///
  /// Returns void.
  static Future<void> _handleEnableRecordingNotificationDone(
      String data) async {
    if (data == "true") {
      _resetTimer();
      await _recordingMethodChannel
          .invokeMethod('getFlashInfo', <String, dynamic>{
        'isManagingFiles': _recorderState == RecorderState.exporting ||
            _recorderState == RecorderState.erasing
      });
    } else {
      debugPrint("Recording notifications were not enabled");
    }
  }

  /// Handles the start of the recording process.
  ///
  /// Returns void.
  static void _handleRecordingStarted() {
    if (_recorderState == RecorderState.preparing) {
      _timeoutTimer?.cancel();
      _startTime = DateTime.now();
      _changeState(RecorderState.recording);
    }
  }

  /// Handles the completion of the recording process.
  ///
  /// Returns void.
  static Future<void> _handleRecordingStopped() async {
    if (_recorderState == RecorderState.recording) {
      int recordingDuration = DateTime.now().millisecondsSinceEpoch -
          _startTime.millisecondsSinceEpoch;
      _totalRecordingData =
          (_recordingOutputRate * recordingDuration / 1000.0).ceil().toInt();
      _changeState(RecorderState.exporting);
      _resetTimer();
      await _recordingMethodChannel.invokeMethod('prepareExtract');
    }
  }

  /// Handles the completion of the "get flash info" process.
  ///
  /// Returns void
  static Future<void> _handleGetFlashInfoDone(String? data) async {
    _resetTimer();
    switch (_recorderState) {
      case RecorderState.preparing:
        bool canRecord = data == "true";
        if (!canRecord) {
          _timeoutTimer?.cancel();
          _changeState(RecorderState.full);
          return;
        }
        try {
          await _recordingMethodChannel.invokeMethod('startRecording');
          _timeoutTimer?.cancel();
        } on PlatformException catch (e) {
          debugPrint(e.message!);
        }
        break;
      case RecorderState.exporting:
        await _recordingMethodChannel.invokeMethod('getFileInfo');
        break;
      case RecorderState.erasing:
        await _recordingMethodChannel.invokeMethod('eraseMemory');
        _timeoutTimer?.cancel();
        break;
      default:
        break;
    }
  }

  /// Handles the completion of the "get file info" process.
  ///
  /// Parameters:
  /// - [data] : A comma-separated string representing the file info.
  ///
  /// Returns void.
  static Future<void> _handleGetFileInfoDone(String data) async {
    if (_recorderState == RecorderState.exporting) {
      _resetTimer();
      _exportFileName = "${data.split(",")[1].split(": ")[1]}.csv";
      await _recordingMethodChannel
          .invokeMethod('extractFile', <String, dynamic>{'fileInfo': data});
    }
  }

  /// Handles the process of extracting a file.
  ///
  /// Parameters:
  /// - [data] : A String containing the extracted data.
  ///
  /// Returns void.
  static void _handleExtractingFile(String? data) {
    if (_recorderState == RecorderState.exporting) {
      if (data != null) {
        _resetTimer();
        try {
          _exportedData.add(XSensDotData.fromEventChannel(data));
        } catch (e) {
          debugPrint(e.toString());
          _timeoutTimer?.cancel();
          _changeState(RecorderState.error);
          return;
        }

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

  /// Handles the completion of the extraction of a file.
  ///
  /// Returns void.
  static Future<void> _handleExtractFileDone() async {
    if (_recorderState == RecorderState.exporting) {
      _timeoutTimer?.cancel();
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

  /// Analyzes data and creates jumps from them.
  ///
  /// Returns void.
  static Future<void> _analyzeData() async {
    String content = CsvCreator.createXSensDotCsv(_exportedData);
    bool success = await HttpClient()
        .uploadFile(fileName: _exportFileName, fileContent: content);
    if (success) {
      List<Jump>? jumps = await HttpClient()
          .analyze(fileName: _exportFileName, captureID: _currentCapture!.uID!);

      if (jumps == null) {
        _changeState(RecorderState.error);
        return;
      }

      List<Jump> analyzedJumps =
          await CaptureClient().createJumps(jumps: jumps);
      _currentCapture?.jumpsID.addAll(analyzedJumps.map((jump) => jump.uID!));
    } else {
      // This is supposed to raise an error, but since we don't mind about
      // the server communication, do not raise
      // _changeState(RecorderState.error);
      _changeState(RecorderState.idle);
      return;
    }
    _changeState(RecorderState.idle);
  }

  /// Changes the state to idle when the memory is done erasing.
  ///
  /// Returns void.
  static void _handleEraseMemoryDone() async {
    _changeState(RecorderState.idle);
  }

  /// Changes the state.
  ///
  /// Parameters:
  /// - [state] : The new [RecorderState].
  ///
  /// Returns void.
  static void _changeState(RecorderState state) {
    _recorderState = state;
    XSensDotRecordingService().notifySubscribers(state);
  }

  /// Resets the timer.
  ///
  /// Returns void.
  static void _resetTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(_timeoutDuration, () {
      _changeState(RecorderState.error);
    });
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
