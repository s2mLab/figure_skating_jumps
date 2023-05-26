// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "AppDelegate.h"
#import <Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"

#import "MethodChannelNames.h"
#import "XSensDotDeviceScanner.h"

@interface AppDelegate ()
@property (nonatomic, strong) XSensDotDeviceScanner *xSensDotDeviceScanner;
@end

@implementation AppDelegate {
  FlutterEventSink _eventSink;
}

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  FlutterViewController* controller =
      (FlutterViewController*)self.window.rootViewController;

  // Declaring all the xsens devices
  self.xSensDotDeviceScanner = [[XSensDotDeviceScanner alloc] init];


  FlutterMethodChannel* scanner = [
      FlutterMethodChannel methodChannelWithName:ChannelNames(ScanChannel) binaryMessenger:controller];
  [scanner setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    [self handleScanCalls:call result:result];
  }];

  /*
   * THIS IS AN EXAMPLE ON HOW TO USE EVENT. TO BE USED LATER
  FlutterEventChannel* chargingChannel = [FlutterEventChannel
      eventChannelWithName:@"samples.flutter.io/charging"
           binaryMessenger:controller];
  [chargingChannel setStreamHandler:self];
  */
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

/**
  * Handles the Scan Method channel calls
  *
  * @param call The method to call and its parameters
  * @param result The result to send back to the flutter project
  */
- (void)handleScanCalls:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"startScan"]) {
    [self startScan:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)startScan:(FlutterResult)result {
  [self.xSensDotDeviceScanner startScan];
  result(nil);
}

/**
  * FROM THAT POINT IT IS AN EXAMPLE ON HOW TO USE EVENTS. TO USE LATER
- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink {
  _eventSink = eventSink;
  [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
  [self sendBatteryStateEvent];
  [[NSNotificationCenter defaultCenter]
   addObserver:self
      selector:@selector(onBatteryStateDidChange:)
          name:UIDeviceBatteryStateDidChangeNotification
        object:nil];
  return nil;
}

- (void)onBatteryStateDidChange:(NSNotification*)notification {
  [self sendBatteryStateEvent];
}

- (void)sendBatteryStateEvent {
  if (!_eventSink) return;
  UIDeviceBatteryState state = [[UIDevice currentDevice] batteryState];
  switch (state) {
    case UIDeviceBatteryStateFull:
    case UIDeviceBatteryStateCharging:
      _eventSink(@"charging");
      break;
    case UIDeviceBatteryStateUnplugged:
      _eventSink(@"discharging");
      break;
    default:
      _eventSink([FlutterError errorWithCode:@"UNAVAILABLE"
                                     message:@"Charging status unavailable"
                                     details:nil]);
      break;
  }
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  _eventSink = nil;
  return nil;
}
*/
@end
