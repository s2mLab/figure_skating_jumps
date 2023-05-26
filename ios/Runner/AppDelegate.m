// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "AppDelegate.h"
#import <Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"

#import "MethodChannelNames.h"
#import "EventChannelParameters.h"

#import "XSensDotDeviceScanner.h"
#import "XSensDotScanStreamHandler.h"
#import "XSensDotConnectionStreamHandler.h"


@interface AppDelegate ()
@property (nonatomic, strong) XSensDotDeviceScanner *xSensDotDeviceScanner;
@property (nonatomic, strong) XSensDotScanStreamHandler *xSensDotScanStreamHandler;

@property (nonatomic, strong) XSensDotConnectionStreamHandler *xSensDotConnectionStreamHandler;
@end

@implementation AppDelegate {
  FlutterEventSink _eventSink;
}

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

  // Initialize all the xsens properties
  self.xSensDotDeviceScanner = [[XSensDotDeviceScanner alloc] init];
  self.xSensDotScanStreamHandler = [[XSensDotScanStreamHandler alloc] init];
  self.xSensDotConnectionStreamHandler = [[XSensDotConnectionStreamHandler alloc] init];
 
  [self setUpChannels];
  
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)setUpChannels{
  FlutterViewController* controller =
      (FlutterViewController*)self.window.rootViewController;

  // Methods
  FlutterMethodChannel* scanner = [
      FlutterMethodChannel methodChannelWithName:ChannelNames(ScanChannel) 
                                 binaryMessenger:controller];
  [scanner setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
      [self handleScanCalls:call result:result];
  }];

  FlutterMethodChannel* connection = [
      FlutterMethodChannel methodChannelWithName:ChannelNames(ConnectionChannel) 
                                 binaryMessenger:controller];
  [connection setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
      [self handleConnectionCalls:call result:result];
  }];



  // Events
  FlutterEventChannel* scanChannelEvent = [
    FlutterEventChannel eventChannelWithName:ChannelEventNames(ScanChannelEvent)
                             binaryMessenger:controller];
  [scanChannelEvent setStreamHandler:self.xSensDotScanStreamHandler];

  FlutterEventChannel* connectionChannelEvent = [
    FlutterEventChannel eventChannelWithName:ChannelEventNames(ConnectionChannelEvent)
                             binaryMessenger:controller];
  [connectionChannelEvent setStreamHandler:self.xSensDotScanStreamHandler];

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
  * Handles the Connection Method channel calls
  *
  * @param call The method to call and its parameters
  * @param result The result to send back to the flutter project
  */
- (void)handleConnectionCalls:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"connectXSensDot"]) {
      [self connectXSensDot:call result:result];
    } else {
      result(FlutterMethodNotImplemented);
    }
}

 /**
   * Connects to XSens Dot device
   *
   * @param call The call containing the MAC address of the device
   * @param result The result to send back to the flutter project. Sends an error
   * if the MAC address argument does not exists
   */
- (void)connectXSensDot:(FlutterMethodCall*)call result:(FlutterResult)result {
  result(@"tata");
}

@end
