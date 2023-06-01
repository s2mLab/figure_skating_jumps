#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import <XsensDotSdk/XsensDotConnectionManager.h>

@interface XSensDotRecordingStreamHandler : NSObject<FlutterStreamHandler, XsensDotConnectionDelegate>
- (void)connectDevice:(XsensDotDevice *)device;
- (void)disconnectDevice;
- (void)setRate:(int)rate;
- (void)prepareRecording;
- (void)startRecording;
- (void)stopRecording;
- (void)prepareExtract;
@end
