#import "XSensDotConnectionStreamHandler.h"


typedef NS_ENUM(NSInteger, DeviceState) {
    DeviceStateDisconnected = 0,
    DeviceStateConnecting = 1,
    DeviceStateConnected = 2,
    DeviceStateInitialized = 3,
    DeviceStateReconnecting = 4,
    DeviceStateStartReconnecting = 5
};


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
    
    [self sendEvent:@(DeviceStateConnecting)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (![self->_connectedDevice isInitialized]) {
            // Wait for a bit of time before testing again
            [NSThread sleepForTimeInterval:0.1];
            // We are suppose to wait for the device to be initalized before sending the initialized event
            // but since "isInitialized" never turns to true we just skip this process...
            break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self onDeviceInitialized];
        });
    });
}

- (void)onDeviceInitialized
{
    [self sendEvent:@(DeviceStateInitialized)];
}

- (XsensDotDevice*)connectedDevice {
    return _connectedDevice;
}

- (void)disconnectDevice
{
    _connectedDevice = nil;
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
    [self disconnectDevice];
    _eventSink = nil;
    return nil;
}

- (void)sendEvent:(id)event {
  if (_eventSink) {
    _eventSink(event);
  }
}

@end
