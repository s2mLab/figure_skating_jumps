#import "XSensDotMeasuringStreamHandler.h"

@implementation XSensDotMeasuringStreamHandler{
    FlutterEventSink _eventSink;
    XsensDotDevice * _currentDevice;
  }

- (id)init {
    self = [super init];
    if (self){
        /// Set xsensDot connection delete
        [XsensDotConnectionManager setConnectionDelegate:self];
    }
    return self;
}

/// Add notifications
- (void)addObservers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(onDeviceTagRead:) name:kXsensDotNotificationDeviceNameDidRead object:nil];
}

- (void)onDeviceTagRead:(NSNotification *)sender
{
    // TODO Call the dart stream here to notify that data were received
    printf("coucou");
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    if (_currentDevice){
        // If a device was previously added, start measuring with it
        _currentDevice.plotMeasureMode = XSBleDevicePayloadCompleteEuler;
        _currentDevice.plotLogEnable = YES;
        _currentDevice.plotMeasureEnable = YES;
        [self addObservers];
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
    if (_eventSink) {
        // If it already listening to something
        _currentDevice.plotMeasureMode = XSBleDevicePayloadCompleteEuler;
        _currentDevice.plotLogEnable = YES;
        _currentDevice.plotMeasureEnable = YES;
        [self addObservers];
    }
}

@end
