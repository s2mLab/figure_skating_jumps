#import "XSensDotInterface.h"
#import <XsensDotSdk/XsensDotConnectionManager.h>

@interface XSensDotInterface ()<XsensDotConnectionDelegate>

@property (strong, nonatomic) NSMutableArray<XsensDotDevice *> *deviceList;
@property (strong, nonatomic) NSMutableArray *connectList;

@end

@implementation XSensDotInterface

- (id)init {
    if  (self = [super init]){
        self.deviceList = [NSMutableArray arrayWithCapacity:20];
        self.connectList = [NSMutableArray arrayWithCapacity:20];

        [XsensDotConnectionManager setConnectionDelegate:self];
        return self;
    } else {
        return nil;
    }

}

- (void)startScan {
    [self.deviceList removeAllObjects];
    if (self.connectList.count != 0)
    {
        [self.deviceList addObjectsFromArray:self.connectList];
    }

    /// Start scan
    [XsensDotConnectionManager scan];
         
    // [[NSNotificationCenter defaultCenter]
    //     addObserver:self
    //     selector:@selector(onBatteryStateDidChange:)
    //     object:nil];
}

// - (void)onBatteryStateDidChange:(NSNotification*)notification {
//   [self sendBatteryStateEvent];
// }

// - (void)sendBatteryStateEvent {
//   if (!_eventSink) return;
//   UIDeviceBatteryState state = [[UIDevice currentDevice] batteryState];
//   switch (state) {
//     case UIDeviceBatteryStateFull:
//     case UIDeviceBatteryStateCharging:
//       _eventSink(@"charging");
//       break;
//     case UIDeviceBatteryStateUnplugged:
//       _eventSink(@"discharging");
//       break;
//     default:
//       _eventSink(@"tata2");
//       break;
//   }
// }

- (void)stopScan {
    [XsensDotConnectionManager stopScan];
}

@end