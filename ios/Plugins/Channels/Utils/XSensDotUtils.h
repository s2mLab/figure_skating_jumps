#import <Foundation/Foundation.h>

#import <XsensDotSdk/XsensDotConnectionManager.h>

@interface XSensDotUtils : NSObject
+ (NSString * _Nonnull)serializeData:(XsensDotPlotData * _Nonnull) data withPackageCounter:(int)counter;
@end
