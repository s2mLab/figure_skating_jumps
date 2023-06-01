#import "XSensDotRecordingStreamHandler.h"

typedef NS_ENUM(NSInteger, RecordingStatus) {
    RecordingStatusSetRate,
    RecordingStatusEnableRecordingNotificationDone,
    RecordingStatusRecordingStarted,
    RecordingStatusRecordingStopped,
    RecordingStatusGetFlashInfoDone,
    RecordingStatusGetFileInfoDone,
    RecordingStatusExtractingFile,
    RecordingStatusExtractFileDone,
    RecordingStatusEraseMemoryDone
};

NSString* recordingStatusAsString(RecordingStatus status){
    switch (status){
        case RecordingStatusSetRate: return @"SetRate";
        case RecordingStatusEnableRecordingNotificationDone: return @"EnableRecordingNotificationDone";
        case RecordingStatusRecordingStarted: return @"RecordingStarted";
        case RecordingStatusRecordingStopped: return @"RecordingStopped";
        case RecordingStatusGetFlashInfoDone: return @"GotFlashInfo";
        case RecordingStatusGetFileInfoDone: return @"GotFileInfo";
        case RecordingStatusExtractingFile: return @"ExtractingFile";
        case RecordingStatusExtractFileDone: return @"ExtractFileDone";
        case RecordingStatusEraseMemoryDone: return @"EraseMemoryDone";
    }
}

@implementation XSensDotRecordingStreamHandler{
    FlutterEventSink _eventSink;
    XsensDotDevice * _currentDevice;
    int _packageCounter; // This should not be useful, but for some reason, the vanilla packageCounter from XSens does not increment
}

- (id)init {
    self = [super init];
    if (self){
        /// Set xsensDot connection delete
        [XsensDotConnectionManager setConnectionDelegate:self];
    }
    return self;
}

- (void)connectDevice:(XsensDotDevice *)device{
    _currentDevice = device;
}

- (void)disconnectDevice
{
    [self stopRecording];
    _currentDevice = nil;
}

- (void)setRate:(int)rate{
    _currentDevice.outputRate = rate;
    [self sendEvent:[self serializeWithStatus:RecordingStatusSetRate withData:nil]];
}

- (void)prepareRecording{
    __weak typeof(self) weakSelf = self;
    [_currentDevice setFlashInfoDoneBlock: ^(XSFlashInfoStatus status){
        NSLog(@"Coucou");
        NSString* isReady = (status == XSFlashInfoIsReady ? @"true" : @"false");
        [weakSelf sendEvent:[weakSelf serializeWithStatus:RecordingStatusGetFlashInfoDone
                                         withData:isReady]
        ];
    }];
    [_currentDevice getFlashInfo];
}

- (void)startRecording
{    
    [_currentDevice startRecording:0xFFFF]; // 0xFFFF indicate infinite amount of time
    [self sendEvent:[self serializeWithStatus:RecordingStatusRecordingStarted withData:nil]];
}

- (void)stopRecording
{
    [_currentDevice stopRecording];
    [self sendEvent:[self serializeWithStatus:RecordingStatusRecordingStopped withData:nil]];
}

- (void)prepareExtract
{
    // TODO
}

- (FlutterError*)onListenWithArguments:(id)listener
                             eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    _eventSink = nil;
    return nil;
}


- (NSString*) serializeWithStatus:(RecordingStatus)status withData:(id)data{
    NSDictionary *jsonObject = @{
        @"status": recordingStatusAsString(status),
        @"data": (data != nil ? data : @""),
    };

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:nil];


    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)sendEvent:(NSString*)event {
  if (_eventSink) {
    _eventSink(event);
  }
}

@end
