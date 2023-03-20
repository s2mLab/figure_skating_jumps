enum MethodChannelNames {
  xSensDotChannel("xsens-dot-method-channel"),
  bluetoothChannel("bluetooth-permission-method-channel"),
  recordingChannel("recording-method-channel");

  const MethodChannelNames(this.channelName);

  final String channelName;
}
