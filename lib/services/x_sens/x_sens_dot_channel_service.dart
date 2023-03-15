import 'dart:async';

import 'package:figure_skating_jumps/enums/method_channel_names.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_data_service.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class XSensDotChannelService {
  static final _xSensMethodChannel = MethodChannel(MethodChannelNames.xSensDotChannel.channelName);

  static final XSensDotChannelService _xSensDotChannelService =
      XSensDotChannelService._internal();

  factory XSensDotChannelService() {
    return _xSensDotChannelService;
  }

  XSensDotChannelService._internal();

  Future<String> getSDKVersion() async {
    try {
      return await _xSensMethodChannel.invokeMethod('getSDKVersion');
    } on PlatformException catch (e) {
      return e.message!;
    }
  }

  Future<void> startScan() async {
    try {
      await _xSensMethodChannel.invokeMethod('startScan');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  Future<void> stopScan() async {
    try {
      await _xSensMethodChannel.invokeMethod('stopScan');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  Future<String> connectXSensDot({String macAddress = 'D4:22:CD:00:19:F4'}) async {
    try {
      return await _xSensMethodChannel.invokeMethod(
          'connectXSensDot', <String, dynamic>{'address': macAddress});
    } on PlatformException catch (e) {
      return e.message!;
    }
  }

  Future<String> disconnectXSensDot() async {
    try {
      return await _xSensMethodChannel.invokeMethod('disconnectXSensDot');
    } on PlatformException catch (e) {
      return e.message!;
    }
  }

  Future<bool> setRate(int rate) async {
    try {
      await _xSensMethodChannel
          .invokeMethod('setRate', <String, dynamic>{'rate': rate});
      return true;
    } on PlatformException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  Future<void> startMeasuring() async {
    try {
      XSensDotDataService().clearMeasuredData();
      await _xSensMethodChannel.invokeMethod('startMeasuring');
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  Future<bool> stopMeasuring() async {
    try {
          await _xSensMethodChannel.invokeMethod('stopMeasuring');
          return true;
    } on PlatformException catch (e) {
      debugPrint(e.message!);
      return false;
    }
  }
}
