enum MethodChannelNames {
  bluetoothChannel("bluetooth-permission-method-channel"),
  recordingChannel("recording-method-channel"),
  measuringChannel("measuring-method-channel"),
  connectionChannel("connection-method-channel"),
  scanChannel("scan-method-channel");

  const MethodChannelNames(this.channelName);

  final String channelName;
}
