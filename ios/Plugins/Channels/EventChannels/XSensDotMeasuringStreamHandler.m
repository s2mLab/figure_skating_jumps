#import "XSensDotMeasuringStreamHandler.h"

#import "XSensDotUtils.h"

#import <unistd.h>

@implementation XSensDotMeasuringStreamHandler{
    FlutterEventSink _eventSink;
    XsensDotDevice * _currentDevice;
    int _packageCounter; // This should not be useful, but for some reason, the vanilla packageCounter from XSens does not increment
  }

- (id)init {
    self = [super init];
    if (self){
        /// Set xsensDot connection delete
        [XsensDotConnectionManager setConnectionDelegate:self];
    }
    return self;
}

- (void)connectDevice:(XsensDotDevice *)device{
    _currentDevice = device;
}

- (void)disconnectDevice
{
    [self stopMeasuring];
    _currentDevice = nil;
}

- (void)setRate:(int)rate{
    _currentDevice.outputRate = rate;
}

- (void)startMeasuring
{
    // If it already listening to something
    _currentDevice.plotMeasureMode = XSBleDevicePayloadHighFidelityNoMag;
    _packageCounter = 0;
    
    // Set the data received callback
    __weak typeof(self) weakSelf = self;
    [_currentDevice setDidParsePlotDataBlock:^(XsensDotPlotData * _Nonnull data){
        [weakSelf onReceivedData:data];
    }];
        
    _currentDevice.plotMeasureEnable = YES;
}

- (void)stopMeasuring
{
    _currentDevice.plotMeasureEnable = NO;
}

- (void)onReceivedData:(XsensDotPlotData * _Nonnull) data
{
    _packageCounter++;
    NSString* dataAsString = [XSensDotUtils serializeData:data withPackageCounter:_packageCounter];
    [self sendEvent:dataAsString];
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  _eventSink = nil;
  return nil;
}

- (void)sendEvent:(NSString*)event {
  if (_eventSink) {
    _eventSink(event);
  }
}

@end
