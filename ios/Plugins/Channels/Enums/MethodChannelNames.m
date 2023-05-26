#import "MethodChannelNames.h"

NSString *ChannelNames(MethodChannelNames methodChannelName) {
    switch (methodChannelName) {
        case BluetoothChannel:
            return @"bluetooth-permission-method-channel";
        case RecordingChannel:
            return @"recording-method-channel";
        case MeasuringChannel:
            return @"measuring-method-channel";
        case ConnectionChannel:
            return @"connection-method-channel";
        case ScanChannel:
            return @"scan-method-channel";
        default:
            return @"";
    }
}