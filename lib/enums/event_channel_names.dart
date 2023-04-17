/// This enum contains the differents event channel names used to receive
/// events from the Kotlin project
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
