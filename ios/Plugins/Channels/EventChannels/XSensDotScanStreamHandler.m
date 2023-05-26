#import "XSensDotScanStreamHandler.h"

@implementation XSensDotScanStreamHandler{
    FlutterEventSink _eventSink;
  }

- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    //   [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    //   [self sendBatteryStateEvent];
    //   [[NSNotificationCenter defaultCenter]
    //    addObserver:self
    //       selector:@selector(onBatteryStateDidChange:)
    //           name:UIDeviceBatteryStateDidChangeNotification
    //         object:nil];
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

@end
