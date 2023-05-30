#import "XSensDotConnectionStreamHandler.h"

@implementation XSensDotConnectionStreamHandler{
    FlutterEventSink _eventSink;
    XsensDotDevice* _connectedDevice;
  }

- (id)init {
    self = [super init];
    if (self){
        /// Set xsensDot connection delete
        [XsensDotConnectionManager setConnectionDelegate:self];
    }
    return self;
}

- (void)connect:(XsensDotDevice*)device {
    [XsensDotConnectionManager connect:device];
    _connectedDevice = device;
}

- (XsensDotDevice*)connectedDevice {
    return _connectedDevice;
}

- (FlutterError*)onListenWithArguments:(id)listener
                             eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    return nil;
}

/// Discovered XsensDot device
/// @param device XsensDotDevice
- (void)onDeviceConnectSucceeded:(XsensDotDevice *)device
{
    if (self->_eventSink != nil) {
        self->_eventSink([NSNumber numberWithInt:2]);
    }
}

- (void)onDeviceDisconnected:(XsensDotDevice *_Nonnull)device
{
    if (self->_eventSink != nil) {
        self->_eventSink([NSNumber numberWithInt:0]);
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
