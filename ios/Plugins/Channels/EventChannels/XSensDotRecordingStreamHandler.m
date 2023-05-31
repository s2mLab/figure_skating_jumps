#import "XSensDotRecordingStreamHandler.h"

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
    [self stopMeasuring];
    _currentDevice = nil;
}

- (void)setRate:(int)rate{
    _currentDevice.outputRate = rate;
}

- (void)startMeasuring
{
    // If it already listening to something
    _currentDevice.plotMeasureMode = XSBleDevicePayloadHighFidelityNoMag;
    _packageCounter = 0;
    
    // Set the data received callback
    __weak typeof(self) weakSelf = self;
    [_currentDevice setDidParsePlotDataBlock:^(XsensDotPlotData * _Nonnull data){
        [weakSelf onReceivedData:data];
    }];
        
    _currentDevice.plotMeasureEnable = YES;
}

- (void)stopMeasuring
{
    _currentDevice.plotMeasureEnable = NO;
}

- (void)onReceivedData:(XsensDotPlotData * _Nonnull) data
{
    _packageCounter++;
    NSString* dataAsString = [self serialize:data withPackageCounter:_packageCounter];
    // TODO Call the dart stream here to notify that data were received
    [self sendEvent:dataAsString];
}

- (NSString *)serialize:(XsensDotPlotData * _Nonnull) data withPackageCounter:(int)counter
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];

    NSMutableArray *accArray = [NSMutableArray array];
    [accArray addObject:@(data.acc0)];
    [accArray addObject:@(data.acc1)];
    [accArray addObject:@(data.acc2)];
    [json setObject:accArray forKey:@"acc"];

    NSMutableArray *gyrArray = [NSMutableArray array];
    [gyrArray addObject:@(data.gyr0)];
    [gyrArray addObject:@(data.gyr1)];
    [gyrArray addObject:@(data.gyr2)];
    [json setObject:gyrArray forKey:@"gyr"];

    NSMutableArray *eulerArray = [NSMutableArray array];
    [eulerArray addObject:@(data.euler0)];
    [eulerArray addObject:@(data.euler1)];
    [eulerArray addObject:@(data.euler2)];
    [json setObject:eulerArray forKey:@"euler"];

    [json setObject:@(data.timeStamp) forKey:@"time"];
    [json setObject:@(counter) forKey:@"id"];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return jsonString;
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

- (void)sendEvent:(NSString*)event {
  if (_eventSink) {
    _eventSink(event);
  }
}

@end
