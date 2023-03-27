class TimeConverter {
  static String intToTime(int duration) {
    String time = "";
    int nbHours = (duration / 3600).floor();
    duration -= nbHours * 3600;
    int nbMinutes = (duration / 60).floor();
    duration -= nbMinutes * 60;
    int nbSeconds = duration;

    if (nbHours > 0) time += "${nbHours.toString()}h ";
    if (nbMinutes > 0) time += "${nbMinutes.toString()}m ";

    return "$time${nbSeconds.toString()}s";
  }

  // https://stackoverflow.com/a/54775297/13775984
  static String printSecondsAndMilli(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:${twoDigitSeconds}s";
  }
}
