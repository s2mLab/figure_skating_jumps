import 'dart:async';

import 'package:figure_skating_jumps/enums/event_channel_names.dart';
import 'package:figure_skating_jumps/enums/x_sens/measuring/measurer_state.dart';
import 'package:figure_skating_jumps/enums/x_sens/measuring/measuring_status.dart';
import 'package:figure_skating_jumps/enums/method_channel_names.dart';
import 'package:figure_skating_jumps/interfaces/i_observable.dart';
import 'package:figure_skating_jumps/interfaces/i_x_sens_dot_streaming_data_subscriber.dart';
import 'package:figure_skating_jumps/models/x_sens_dot_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class XSensDotStreamingDataService
    implements
        IObservable<IXSensDotMeasuringDataSubscriber, List<XSensDotData>> {
  static const int _streamingRate = 12;
  static final XSensDotStreamingDataService _xSensDotDataService =
      XSensDotStreamingDataService._internal();
  static final _xSensMeasuringMethodChannel =
      MethodChannel(MethodChannelNames.measuringChannel.channelName);
  static final _xSensMeasuringChannel =
      EventChannel(EventChannelNames.measuringChannel.channelName);
  static final _xSensMeasuringStatusChannel =
      EventChannel(EventChannelNames.measuringStatusChannel.channelName);
  static MeasurerState _state = MeasurerState.idle;
  static final List<XSensDotData> _measuredData = [];
  final List<IXSensDotMeasuringDataSubscriber> _subscribers = [];
  static Timer? _errorTimer;
  static const Duration _maxDelay = Duration(seconds: 30);

  factory XSensDotStreamingDataService() {
    _xSensMeasuringChannel.receiveBroadcastStream().listen((event) {
      _addData(event as String);
    });
    _xSensMeasuringStatusChannel.receiveBroadcastStream().listen((event) {
      _handleMeasuringStateChange(event as String);
    });
    return _xSensDotDataService;
  }

  XSensDotStreamingDataService._internal();

  List<XSensDotData> get measuredData {
    return _measuredData;
  }

  /// Starts the measuring process by clearing previously measured data,
  /// setting the MeasurerState to preparing, and setting the measuring rate
  /// if the device initialization is already done.
  ///
  /// Parameters:
  /// - [isDeviceInitDone] : A boolean value indicating if the device initialization is done or not.
  ///
  /// Returns void.
  Future<void> startMeasuring(bool isDeviceInitDone) async {
    _measuredData.clear();
    _state = MeasurerState.preparing;
    if (isDeviceInitDone) {
      await _setMeasuringRate();
    }
  }

  /// Stops the measuring process and sets the MeasurerState to idle.
  ///
  /// Returns void.
  Future<void> stopMeasuring() async {
    await _xSensMeasuringMethodChannel.invokeMethod('stopMeasuring');
    _state = MeasurerState.idle;
  }

  /// Handles changes in measuring state based on the given event.
  /// It checks if the event is related to initialization or setting measuring rate
  /// and updates the MeasurerState accordingly.
  ///
  /// Parameters:
  /// - [event] : A String value representing the event that caused the measuring state change.
  ///
  /// Returns void
  static Future<void> _handleMeasuringStateChange(String event) async {
    var status = MeasuringStatus.values.firstWhere((el) => el.status == event);

    switch (status) {
      case MeasuringStatus.initDone:
        if (_state == MeasurerState.preparing) {
          await _setMeasuringRate();
        }
        break;
      case MeasuringStatus.setRate:
        if (_state == MeasurerState.preparing) {
          _errorTimer?.cancel();
          await _xSensMeasuringMethodChannel.invokeMethod('startMeasuring');
          _state = MeasurerState.measuring;
        }
        break;
    }
  }

  /// Adds the given data to the list of previously measured data and
  /// notifies the subscribers with the updated data list.
  ///
  /// Parameters:
  /// - [data] : A String value representing the data to be added.
  ///
  /// Returns void
  static void _addData(String data) {
    _measuredData.add(XSensDotData.fromEventChannel(data));
    XSensDotStreamingDataService().notifySubscribers(_measuredData);
  }

  /// Sets the measuring rate to the given streaming rate value.
  /// It also starts a timer to monitor the duration of the setting process
  /// and handles any errors that may occur during the process.
  ///
  /// Returns void
  static Future<void> _setMeasuringRate() async {
    _errorTimer?.cancel();
    _errorTimer = Timer(_maxDelay, () {
      _state = MeasurerState.idle;
      debugPrint("Setting measuring rate was too long");
    });
    try {
      await _xSensMeasuringMethodChannel
          .invokeMethod('setRate', <String, dynamic>{'rate': _streamingRate});
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  @override
  @protected
  void notifySubscribers(List<XSensDotData> data) {
    for (IXSensDotMeasuringDataSubscriber s in _subscribers) {
      s.onDataReceived(data);
    }
  }

  @override
  List<XSensDotData> subscribe(IXSensDotMeasuringDataSubscriber subscriber) {
    _subscribers.add(subscriber);
    return _measuredData;
  }

  @override
  void unsubscribe(IXSensDotMeasuringDataSubscriber subscriber) {
    _subscribers.remove(subscriber);
  }
}
