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
  static MesurerState _state = MesurerState.idle;
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

  Future<void> startMeasuring(bool isDeviceInitDone) async {
    _measuredData.clear();
    _state = MesurerState.preparing;
    if (isDeviceInitDone) {
      await _setMeasuringRate();
    }
  }

  Future<void> stopMeasuring() async {
    await _xSensMeasuringMethodChannel.invokeMethod('stopMeasuring');
    _state = MesurerState.idle;
  }

  static Future<void> _handleMeasuringStateChange(String event) async {
    var status = MeasuringStatus.values.firstWhere((el) => el.status == event);

    switch (status) {
      case MeasuringStatus.initDone:
        if (_state == MesurerState.preparing) {
          await _setMeasuringRate();
        }
        break;
      case MeasuringStatus.setRate:
        if (_state == MesurerState.preparing) {
          _errorTimer?.cancel();
          await _xSensMeasuringMethodChannel.invokeMethod('startMeasuring');
          _state = MesurerState.measuring;
        }
        break;
    }
  }

  static void _addData(String data) {
    _measuredData.add(XSensDotData.fromEventChannel(data));
    XSensDotStreamingDataService().notifySubscribers(_measuredData);
  }

  static Future<void> _setMeasuringRate() async {
    _errorTimer?.cancel();
    _errorTimer = Timer(_maxDelay, () {
      _state = MesurerState.idle;
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
