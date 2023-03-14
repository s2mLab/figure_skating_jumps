import 'package:figure_skating_jumps/enums/event_channel_names.dart';
import 'package:figure_skating_jumps/models/xsens_dot_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../interfaces/i_observable.dart';
import '../../interfaces/i_x_sens_dot_streaming_data_subscriber.dart';

class XSensDotDataService implements IObservable<IXSensDotMeasuringDataSubscriber, List<XSensDotData>> {
  static final XSensDotDataService _xSensDotDataService = XSensDotDataService._internal();
  static final _xSensMeasuringChannel = EventChannel(EventChannelNames.measuringChannel.channelName);
  static final List<XSensDotData> _measuredData = [];
  final List<IXSensDotMeasuringDataSubscriber> _subscribers = [];

  factory XSensDotDataService() {
    _xSensMeasuringChannel.receiveBroadcastStream().listen((event) {_addData(event as String);});
    return _xSensDotDataService;
  }

  XSensDotDataService._internal();

  List<XSensDotData> get measuredData {
    return _measuredData;
  }

  void clearMeasuredData() {
    _measuredData.clear();
  }

  static void _addData(String data) {
    _measuredData.add(XSensDotData.fromEventChannel(data));
    XSensDotDataService().notifySubscribers(_measuredData);
  }

  @override
  @protected void notifySubscribers(List<XSensDotData> data) {
    for (IXSensDotMeasuringDataSubscriber s in _subscribers) {
      s.onDataReceived(data);
    }
  }

  @override
  List<XSensDotData> subscribe(IXSensDotMeasuringDataSubscriber subscriber) {
    _subscribers.add(subscriber);
    return _measuredData;
  }

}