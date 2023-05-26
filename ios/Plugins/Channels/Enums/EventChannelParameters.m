#import "EventChannelParameters.h"

NSString *ChannelEventNames(EventChannelParameters eventChannelParameters) {
    switch (eventChannelParameters) {
        case BluetoothChannelEvent:
            return @"xsens-dot-bluetooth-permission";
        case ConnectionChannelEvent:
            return @"xsens-dot-connection";
        case MeasuringChannelEvent:
            return @"xsens-dot-measuring";
        case MeasuringStatusChannelEvent:
            return @"xsens-dot-measuring-status";
        case RecordingChannelEvent:
            return @"xsens-dot-recording";
        case ScanChannelEvent:
            return @"xsens-dot-scan";
        default:
            return @"";
    }
}
