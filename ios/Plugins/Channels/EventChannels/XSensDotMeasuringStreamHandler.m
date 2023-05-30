#import "XSensDotMeasuringStreamHandler.h"

@implementation XSensDotMeasuringStreamHandler{
    FlutterEventSink _eventSink;
    XsensDotDevice * _currentDevice;
  }

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    if (_currentDevice){
        _currentDevice.plotMeasureMode = XSBleDevicePayloadCompleteEuler;
        _currentDevice.plotLogEnable = YES;
        _currentDevice.plotMeasureEnable = YES;
    }
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

- (void)currentDevice:(XsensDotDevice *)device{
    _currentDevice = device;
}

@end
