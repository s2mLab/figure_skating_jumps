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
    
//    // Get callback id
//        
//        // Prepare a timer like self calling task
//        void (^callback)(void) = ^() {
//            int time = (int) CFAbsoluteTimeGetCurrent();
//            
//            eventSink([NSString stringWithFormat:@"Hello Listener! %d", time]);
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), callback);
//            
//        };
//        
//        // Run task
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), callback);
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
