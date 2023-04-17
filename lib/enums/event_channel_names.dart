/// This enum represents the different channels used to exchange data with
/// the Kotlin side.
enum EventChannelNames {
  bluetoothChannel("xsens-dot-bluetooth-permission"),
  connectionChannel("xsens-dot-connection"),
  measuringChannel("xsens-dot-measuring"),
  measuringStatusChannel("xsens-dot-measuring-status"),
  recordingChannel("xsens-dot-recording"),
  scanChannel("xsens-dot-scan");

  const EventChannelNames(this.channelName);

  final String channelName;
}
