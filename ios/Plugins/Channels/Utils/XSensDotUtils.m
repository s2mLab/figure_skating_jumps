#import "XSensDotUtils.h"

@implementation XSensDotUtils

+ (NSString * _Nonnull)serializeData:(XsensDotPlotData * _Nonnull) data withPackageCounter:(int)counter
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

@end

