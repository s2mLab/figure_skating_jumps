#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import <XsensDotSdk/XsensDotConnectionManager.h>

@interface XSensDotConnectionStreamHandler : NSObject<FlutterStreamHandler, XsensDotConnectionDelegate>
- (void)connect:(XsensDotDevice*)device;
- (XsensDotDevice*)connectedDevice;
@end
