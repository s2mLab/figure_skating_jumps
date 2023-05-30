#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import <XsensDotSdk/XsensDotConnectionManager.h>

@interface XSensDotScanStreamHandler : NSObject<FlutterStreamHandler, XsensDotConnectionDelegate>
- (void)startScan;
- (void)stopScan;
- (XsensDotDevice *)deviceFrom:(NSString*)macAddress;
@end
