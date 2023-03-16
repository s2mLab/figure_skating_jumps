enum MethodChannelNames {
  xSensDotChannel("xsens-dot-method-channel"),
  bluetoothChannel("bluetooth-permission-method-channel");

  const MethodChannelNames(this.channelName);

  final String channelName;
}
