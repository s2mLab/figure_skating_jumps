import 'package:figure_skating_jumps/enums/event_channel_names.dart';
import 'package:figure_skating_jumps/enums/measuring/measurer_state.dart';
import 'package:figure_skating_jumps/enums/measuring/measuring_status.dart';
import 'package:figure_skating_jumps/models/xsens_dot_data.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_channel_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../interfaces/i_observable.dart';
import '../../interfaces/i_x_sens_dot_streaming_data_subscriber.dart';

class XSensDotStreamingDataService
    implements
        IObservable<IXSensDotMeasuringDataSubscriber, List<XSensDotData>> {
  static const int _streamingRate = 12;
  static final XSensDotStreamingDataService _xSensDotDataService =
      XSensDotStreamingDataService._internal();
  static final _xSensMeasuringChannel =
      EventChannel(EventChannelNames.measuringChannel.channelName);
  static final _xSensMeasuringStatusChannel =
      EventChannel(EventChannelNames.measuringStatusChannel.channelName);
  static MeasurerState _state = MeasurerState.idle;
  static final List<XSensDotData> _measuredData = [];
  final List<IXSensDotMeasuringDataSubscriber> _subscribers = [];

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
    _state = MeasurerState.preparing;
    if (isDeviceInitDone) {
      await XSensDotChannelService().setRate(_streamingRate);
    }
  }

  Future<void> stopMeasuring() async {
    await XSensDotChannelService().stopMeasuring();
    _state = MeasurerState.idle;
  }

  static Future<void> _handleMeasuringStateChange(String event) async {
    var status =
    MeasuringStatus.values.firstWhere((el) => el.status == event);

    switch(status) {
      case MeasuringStatus.initDone:
        if(_state == MeasurerState.preparing) {
          await XSensDotChannelService().setRate(_streamingRate);
        }
        break;
      case MeasuringStatus.setRate:
        if(_state == MeasurerState.preparing) {
          await XSensDotChannelService().startMeasuring();
          _state = MeasurerState.measuring;
        }
        break;
    }
  }

  static void _addData(String data) {
    _measuredData.add(XSensDotData.fromEventChannel(data));
    XSensDotStreamingDataService().notifySubscribers(_measuredData);
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
