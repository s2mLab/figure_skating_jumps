// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "AppDelegate.h"
#import <Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"

#import "MethodChannelNames.h"
#import "EventChannelParameters.h"

#import "BluetoothPermissionStreamHandler.h"

#import "XSensDotConnectionStreamHandler.h"
#import "XSensDotMeasuringStreamHandler.h"
#import "XSensDotMeasuringStatusStreamHandler.h"
#import "XSensDotRecordingStreamHandler.h"
#import "XSensDotScanStreamHandler.h"


@interface AppDelegate ()
@property (nonatomic, strong) BluetoothPermissionStreamHandler *bluetoothPermissionStreamHandler;

@property (nonatomic, strong) XSensDotConnectionStreamHandler *xSensDotConnectionStreamHandler;
@property (nonatomic, strong) XSensDotMeasuringStreamHandler *xSensDotMeasuringStreamHandler;
@property (nonatomic, strong) XSensDotMeasuringStatusStreamHandler *xSensDotMeasuringStatusStreamHandler;
@property (nonatomic, strong) XSensDotRecordingStreamHandler *xSensDotRecordingStreamHandler;
@property (nonatomic, strong) XSensDotScanStreamHandler *xSensDotScanStreamHandler;
@end

@implementation AppDelegate {
  FlutterEventSink _eventSink;
}

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    
    // Initialize all the xsens properties
    self.bluetoothPermissionStreamHandler = [[BluetoothPermissionStreamHandler alloc] init];
    self.xSensDotConnectionStreamHandler = [[XSensDotConnectionStreamHandler alloc] init];
    self.xSensDotMeasuringStreamHandler = [[XSensDotMeasuringStreamHandler alloc] init];
    self.xSensDotMeasuringStatusStreamHandler = [[XSensDotMeasuringStatusStreamHandler alloc] init];
    self.xSensDotRecordingStreamHandler = [[XSensDotRecordingStreamHandler alloc] init];
    self.xSensDotScanStreamHandler = [[XSensDotScanStreamHandler alloc] init];
    
    [self setUpChannels];
  
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)setUpChannels{
    NSObject<FlutterBinaryMessenger>* controller =
      (NSObject<FlutterBinaryMessenger>*)self.window.rootViewController;

    // Methods
    FlutterMethodChannel* bluetooth = [
        FlutterMethodChannel methodChannelWithName:ChannelNames(BluetoothChannel) binaryMessenger:controller];
    [bluetooth setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        // TODO?
    }];
    
    FlutterMethodChannel* recording = [
        FlutterMethodChannel methodChannelWithName:ChannelNames(RecordingChannel) binaryMessenger:controller];
    [recording setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        [self handleRecordingCalls:call result:result];
    }];
    
    FlutterMethodChannel* connection = [
        FlutterMethodChannel methodChannelWithName:ChannelNames(ConnectionChannel) binaryMessenger:controller];
    [connection setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        [self handleConnectionCalls:call result:result];
    }];
    
    FlutterMethodChannel* measuring = [
        FlutterMethodChannel methodChannelWithName:ChannelNames(MeasuringChannel) binaryMessenger:controller];
    [measuring setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        [self handleMeasuringCalls:call result:result];
    }];
        
    FlutterMethodChannel* scanner = [
        FlutterMethodChannel methodChannelWithName:ChannelNames(ScanChannel) binaryMessenger:controller];
    [scanner setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        [self handleScanCalls:call result:result];
    }];




    // Events
    FlutterEventChannel* permissionEvent = [
        FlutterEventChannel eventChannelWithName:ChannelEventNames(BluetoothChannelEvent) binaryMessenger:controller];
    [permissionEvent setStreamHandler:self.bluetoothPermissionStreamHandler];
    
    FlutterEventChannel* connectionChannelEvent = [
    FlutterEventChannel eventChannelWithName:ChannelEventNames(ConnectionChannelEvent) binaryMessenger:controller];
    [connectionChannelEvent setStreamHandler:self.xSensDotConnectionStreamHandler];
    
    FlutterEventChannel* measuringChannelEvent = [
    FlutterEventChannel eventChannelWithName:ChannelEventNames(MeasuringChannelEvent) binaryMessenger:controller];
    [measuringChannelEvent setStreamHandler:self.xSensDotMeasuringStreamHandler];
    
    FlutterEventChannel* measuringStatusChannelEvent = [
    FlutterEventChannel eventChannelWithName:ChannelEventNames(MeasuringStatusChannelEvent) binaryMessenger:controller];
    [measuringStatusChannelEvent setStreamHandler:self.xSensDotMeasuringStatusStreamHandler];
    
    FlutterEventChannel* recordingChannelEvent = [
    FlutterEventChannel eventChannelWithName:ChannelEventNames(RecordingChannelEvent) binaryMessenger:controller];
    [recordingChannelEvent setStreamHandler:self.xSensDotRecordingStreamHandler];

    FlutterEventChannel* scanChannelEvent = [
        FlutterEventChannel eventChannelWithName:ChannelEventNames(ScanChannelEvent) binaryMessenger:controller];
    [scanChannelEvent setStreamHandler:self.xSensDotScanStreamHandler];

 }


/**
  * Handles the Connection Method channel calls
  *
  * @param call The method to call and its parameters
  * @param result The result to send back to the flutter project
  */
- (void)handleConnectionCalls:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"connectXSensDot"]) {
        // Get the device associated with the address argument
        NSDictionary *arguments = call.arguments;
        NSString *macAddress = arguments[@"address"];
        XsensDotDevice *device = [self.xSensDotScanStreamHandler deviceFrom:macAddress];
        
        [self.xSensDotConnectionStreamHandler connect:device];
        [self.xSensDotMeasuringStreamHandler connectDevice:device];
        [self.xSensDotRecordingStreamHandler connectDevice:device];
        result(nil);
    } else if ([call.method isEqualToString:@"disconnectXSensDot"]) {
        [self.xSensDotConnectionStreamHandler disconnectDevice];
        [self.xSensDotMeasuringStreamHandler disconnectDevice];
        [self.xSensDotRecordingStreamHandler disconnectDevice];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

/**
  * Handles the Measuring Method channel calls
  *
  * @param call The method to call and its parameters
  * @param result The result to send back to the flutter project
  */
- (void)handleRecordingCalls:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"prepareRecording"]) {
        [self.xSensDotRecordingStreamHandler prepareRecording];
        result(nil);
    } else if ([call.method isEqualToString:@"setRate"]) {
        // Change the rate on the unit
        NSDictionary *arguments = call.arguments;
        id rateValue = arguments[@"rate"];
        if ([rateValue isKindOfClass:[NSNumber class]]) {
            int rate = [rateValue intValue];
            [self.xSensDotRecordingStreamHandler setRate:rate];
        }
        result(nil);
    } else if ([call.method isEqualToString:@"getFlashInfo"]) {
        [self.xSensDotRecordingStreamHandler getFlashInfo];
        result(nil);
    } else if ([call.method isEqualToString:@"startRecording"]) {
        [self.xSensDotRecordingStreamHandler startRecording];
        result(nil);
    } else if ([call.method isEqualToString:@"stopRecording"]) {
        [self.xSensDotRecordingStreamHandler stopRecording];
        result(nil);
    } else if ([call.method isEqualToString:@"prepareExtract"]) {
        [self.xSensDotRecordingStreamHandler prepareExtract];
        result(nil);
    } else if ([call.method isEqualToString:@"getFileInfo"]) {
        [self.xSensDotRecordingStreamHandler getFileInfo];
        result(nil);
    } else if ([call.method isEqualToString:@"extractFile"]) {
        NSDictionary *arguments = call.arguments;
        id fileInfo = arguments[@"fileInfo"];
        [self.xSensDotRecordingStreamHandler extractFileWithFileInfo:fileInfo];
        result(nil);
    } else if ([call.method isEqualToString:@"eraseMemory"]) {
        [self.xSensDotRecordingStreamHandler eraseMemory];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}


/**
  * Handles the Measuring Method channel calls
  *
  * @param call The method to call and its parameters
  * @param result The result to send back to the flutter project
  */
- (void)handleMeasuringCalls:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"startMeasuring"]) {
        [self.xSensDotMeasuringStreamHandler startMeasuring];
        result(nil);
    } else if ([call.method isEqualToString:@"stopMeasuring"]) {
        [self.xSensDotMeasuringStreamHandler stopMeasuring];
        result(nil);
    } else if ([call.method isEqualToString:@"setRate"]) {
        // Change the rate on the unit
        NSDictionary *arguments = call.arguments;
        id rateValue = arguments[@"rate"];
        if ([rateValue isKindOfClass:[NSNumber class]]) {
            int rate = [rateValue intValue];
            [self.xSensDotMeasuringStreamHandler setRate:rate];
        }
        // Notify listeners rate was changed
        [self.xSensDotMeasuringStatusStreamHandler notifyRateIsSet];
        
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}


/**
  * Handles the Scan Method channel calls
  *
  * @param call The method to call and its parameters
  * @param result The result to send back to the flutter project
  */
- (void)handleScanCalls:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"startScan"]) {
        [self.xSensDotScanStreamHandler startScan];
        result(nil);
    } else if ([call.method isEqualToString:@"stopScan"]) {
        [self.xSensDotScanStreamHandler stopScan];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
