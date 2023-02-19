import 'dart:async';

import 'package:figure_skating_jumps/models/device_info.dart';
import 'package:figure_skating_jumps/models/xsens_dot_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class XsensDotService {
  static const xSensChannel = MethodChannel('xsens-dot-channel');
  List<XsensDotData> data = [];
  List<DeviceInfo> availableDevice = [];
  late DeviceInfo connectedDevice;

  Future<String> getSDKVersion() async {
    try {
      return await xSensChannel.invokeMethod('getSDKVersion');
    } on PlatformException catch (e) {
      return e.message!;
    }
  }

  Future<List<dynamic>> getCloseXsensDot() async {
    List<dynamic> res = [];
    try {
      await xSensChannel.invokeMethod('getCloseXsensDot');
      debugPrint("in");
      Timer.periodic(const Duration(seconds: 3), (timer) {});
      res = await xSensChannel.invokeMethod('stopScan') as List<dynamic>;
    } on PlatformException catch (e) {
      debugPrint("err");
      debugPrint(e.message!);
    }
    return res;
  }

  Future<List<dynamic>> stopScan() async {
    List<dynamic> res = [];
    try {} on PlatformException catch (e) {
      debugPrint(e.message!);
    }
    return res;
  }

  Future<String> connectXsensDot() async {
    try {
      return await xSensChannel.invokeMethod(
          'connectXsensDot', <String, dynamic>{'address': 'D4:22:CD:00:19:F4'});
    } on PlatformException catch (e) {
      return e.message!;
    }
  }

  startMeasuring() async {
    try {
      debugPrint(await xSensChannel.invokeMethod('startMeasuring'));
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  stopmeasuring() async {
    try {
      debugPrint(await xSensChannel.invokeMethod('stopMeasuring'));
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }
}
