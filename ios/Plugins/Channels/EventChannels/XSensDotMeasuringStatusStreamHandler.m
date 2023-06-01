#import "XSensDotMeasuringStatusStreamHandler.h"


typedef NS_ENUM(NSInteger, MeasuringStatus) {
    MeasuringStatusInitDone,
    MeasuringStatusSetRate
};

NSString* measuringStatusAsString(MeasuringStatus status){
    switch (status){
        case MeasuringStatusInitDone: return @"InitDone";
        case MeasuringStatusSetRate: return @"SetRate";
    }
}


@implementation XSensDotMeasuringStatusStreamHandler{
    FlutterEventSink _eventSink;
  }

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    return nil;
}

- (void)notifyRateIsSet
{
    [self sendEvent:measuringStatusAsString(MeasuringStatusSetRate)];
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
