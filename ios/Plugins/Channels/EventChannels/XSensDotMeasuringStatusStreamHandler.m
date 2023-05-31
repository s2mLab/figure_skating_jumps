#import "XSensDotMeasuringStatusStreamHandler.h"

@implementation XSensDotMeasuringStatusStreamHandler{
    FlutterEventSink _eventSink;
  }

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    return nil;
}

- (void)notifyRateIsSet
{
    [self sendEvent:@"SetRate"];
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  _eventSink = nil;
  return nil;
}

- (void)sendEvent:(id)event {
  if (_eventSink) {
    _eventSink(event);
  }
}

@end
