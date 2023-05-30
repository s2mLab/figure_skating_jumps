#import "XSensDotScanStreamHandler.h"

@implementation XSensDotScanStreamHandler{
    FlutterEventSink _eventSink;
  }

- (id)init {
    self = [super init];
    if (self){
        /// Set xsensDot connection delete
        [XsensDotConnectionManager setConnectionDelegate:self];
    }
    return self;
}

- (FlutterError*)onListenWithArguments:(id)listener
                             eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    
    /// Start scan
    [self startScan];

    return nil;
}

- (void)startScan {
    /// Start scan
    [XsensDotConnectionManager scan];
}

- (void)stopScan {
    [XsensDotConnectionManager stopScan];
}

/// Discovered XsensDot device
/// @param device XsensDotDevice
- (void)onDiscoverDevice:(XsensDotDevice *)device
{
    if (self->_eventSink != nil) {
        self->_eventSink([NSString stringWithFormat:@"%@,%@", device.macAddress, device.peripheralName]);
    }
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    _eventSink = nil;
    return nil;
}

- (void)sendEvent:(NSString*)event {
  if (_eventSink) {
    _eventSink(event);
  }
}

@end
