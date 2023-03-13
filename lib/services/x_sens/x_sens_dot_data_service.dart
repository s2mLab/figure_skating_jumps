import 'dart:ffi';

import 'package:figure_skating_jumps/enums/event_channel_names.dart';
import 'package:figure_skating_jumps/models/xsens_dot_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class XSensDotDataService {
  static final XSensDotDataService _xSensDotDataService = XSensDotDataService._internal();
  static final _xSensMeasuringChannel = EventChannel(EventChannelNames.measuringChannel.channelName);
  static List<XSensDotData> _measuredData = [];

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
    if (kDebugMode) {
      print(data);
    }
    //TODO create data from string
  }

}