enum XSensDotCsvColumns {
  id("PacketCounter"),
  time("SampleTimeFine"),
  eulerX("Euler_X"),
  eulerY("Euler_Y"),
  eulerZ("Euler_Z"),
  accX("Acc_X"),
  accY("Acc_Y"),
  accZ("Acc_Z"),
  gyrX("Gyr_X"),
  gyrY("Gyr_Y"),
  gyrZ("Gyr_Z");

  const XSensDotCsvColumns(this.title);

  final String title;
}