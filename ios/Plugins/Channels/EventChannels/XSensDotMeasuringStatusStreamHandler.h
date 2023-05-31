#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface XSensDotMeasuringStatusStreamHandler : NSObject<FlutterStreamHandler>
- (void)notifyRateIsSet;
@end
