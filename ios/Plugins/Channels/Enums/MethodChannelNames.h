#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MethodChannelNames) {
    BluetoothChannel,
    RecordingChannel,
    MeasuringChannel,
    ConnectionChannel,
    ScanChannel
};

NSString *ChannelNames(MethodChannelNames methodChannelName);