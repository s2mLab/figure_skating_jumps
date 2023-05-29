#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import <XsensDotSdk/XsensDotConnectionManager.h>

@interface XSensDotScanStreamHandler : NSObject<FlutterStreamHandler, XsensDotConnectionDelegate>
@property (nonatomic, copy) void (^callback)(void);
@property (strong, nonatomic) NSMutableArray<XsensDotDevice *> *deviceList;
@property (strong, nonatomic) NSMutableArray *connectList;
@end
