enum EventChannelNames {
  bluetoothChannel("xsens-dot-bluetooth-permission"),
  connectionChannel("xsens-dot-connection"),
  measuringChannel("xsens-dot-measuring"),
  recordingChannel("xsens-dot-recording"),
  scanChannel("xsens-dot-scan");

  const EventChannelNames(this.channelName);

  final String channelName;
}
