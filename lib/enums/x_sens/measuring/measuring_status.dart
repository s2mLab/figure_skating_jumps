/// This enum represents the status of the measuring process.
enum MeasuringStatus {
  initDone("InitDone"),
  setRate("SetRate");

  const MeasuringStatus(this.status);

  final String status;
}
