#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EventChannelParameters) {
    BluetoothChannelEvent,
    ConnectionChannelEvent,
    MeasuringChannelEvent,
    MeasuringStatusChannelEvent,
    RecordingChannelEvent,
    ScanChannelEvent
};

NSString *ChannelEventNames(EventChannelParameters eventChannelParameters);