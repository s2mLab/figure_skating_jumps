/// This enum represents state of the measuring process.
enum MeasuringStatus {
  initDone("InitDone"),
  setRate("SetRate");

  const MeasuringStatus(this.status);

  final String status;
}
