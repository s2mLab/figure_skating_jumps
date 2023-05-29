#import "XSensDotScanStreamHandler.h"

@implementation XSensDotScanStreamHandler{
    FlutterEventSink _eventSink;
  }

- (id)init {
    self = [super init];
    if (self){
        self.deviceList = [NSMutableArray arrayWithCapacity:20];
        /// Set xsensDot connection delete
        [XsensDotConnectionManager setConnectionDelegate:self];
        /// Add notifications
        [self addObservers];
    }
    return self;
}

- (FlutterError*)onListenWithArguments:(id)listener
                             eventSink:(FlutterEventSink)emitter {
       _eventSink = emitter;
    
        [self.deviceList removeAllObjects];
        /// Start scan
        [XsensDotConnectionManager scan];
    
        return nil;
}

/// Add notifications
- (void)addObservers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(onDeviceBatteryUpdated:) name:kXsensDotNotificationDeviceBatteryDidUpdate object:nil];
    [center addObserver:self selector:@selector(onDeviceTagRead:) name:kXsensDotNotificationDeviceNameDidRead object:nil];
}

/// Discovered XsensDot device
/// @param device XsensDotDevice
- (void)onDiscoverDevice:(XsensDotDevice *)device
{
    NSInteger index = [self.deviceList indexOfObject:device];
    if(index == NSNotFound)
    {
        if(![self.deviceList containsObject:device])
        {
            [self.deviceList addObject:device];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            if (self->_eventSink != nil) {
                NSString *eventString = [NSString stringWithFormat:@"%@,%@", device.macAddress, device.peripheralName];
                self->_eventSink(eventString);
            }
        } @catch (NSException *exception) {
            if (self->_eventSink != nil) {
                NSDictionary *errorDetails = @{
                    NSLocalizedDescriptionKey: exception.reason,
                    @"NSStackTraceKey": exception.callStackSymbols
                };
                FlutterError *error = [FlutterError errorWithCode:@"security" message:exception.reason details:errorDetails];
                self->_eventSink(error);
            }
        }
    });
    
    
//
//    self->_eventSink([NSString stringWithFormat:@"Coucou Listener!"]);
       
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _eventSink = nil;
    self.callback = nil;
    return nil;
}

- (void)sendEvent:(NSString*)event {
  if (_eventSink) {
    _eventSink(event);
  }
}



@end
