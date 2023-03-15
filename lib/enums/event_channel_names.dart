enum EventChannelNames {
  bluetoothChannel("xsens-dot-bluetooth-permission"),
  connectionChannel("xsens-dot-connection"),
  fileExportChannel("xsens-dot-file-export"),
  measuringChannel("xsens-dot-measuring"),
  recordingChannel("xsens-dot-recording"),
  scanChannel("xsens-dot-scan");

  const EventChannelNames(this.channelName);

  final String channelName;
}
