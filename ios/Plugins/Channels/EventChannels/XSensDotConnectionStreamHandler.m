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
    [self addObservers];
    [self onDeviceInitialized];
}

/// Add notifications
- (void)addObservers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(onDeviceInitialized) name:kXsensDotNotificationDeviceInitialized object:nil];
}

- (void)removeObservers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:kXsensDotNotificationDeviceInitialized object:nil];
}

- (void)onDeviceInitialized
{
    [self sendEvent:@(3)];
}

- (XsensDotDevice*)connectedDevice {
    return _connectedDevice;
}

- (void)disconnectDevice
{
    [self removeObservers];
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
