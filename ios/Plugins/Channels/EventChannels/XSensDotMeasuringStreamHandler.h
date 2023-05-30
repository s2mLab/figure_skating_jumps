#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import <XsensDotSdk/XsensDotConnectionManager.h>

@interface XSensDotMeasuringStreamHandler : NSObject<FlutterStreamHandler, XsensDotConnectionDelegate>
- (void)currentDevice:(XsensDotDevice *)device;
@end
