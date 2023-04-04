class TimeConverter {

  static String dateTimeToHoursAndMinutes(DateTime date) =>
      "${date.hour.toString().padLeft(2, "0")}h${date.minute.toString().padLeft(2, "0")}";

  static String dateTimeToSeconds(DateTime date) =>
      "${date.second.toString().padLeft(2, "0")}s";

  static String msToFormatSMs(int ms) {
    int nbSeconds = (ms / 1000).floor();
    ms -= nbSeconds * 1000;

    return "${nbSeconds.toString()}.${ms.toString().padLeft(3, "0")}s";
  }

  static String twoDigitsPadLeft(int n) {
    return n.toString().padLeft(2, "0");
  }

  static String _hourMinuteSecondString(int hours, int minutes, int seconds) {
    if (hours > 0) {
      return "${hours.toString()}h ${minutes.toString().padLeft(2, "0")}m ${seconds.toString().padLeft(2, "0")}s";
    } else if (minutes > 0) {
      return "${minutes.toString()}m ${seconds.toString().padLeft(2, "0")}s";
    }
    return "${seconds.toString()}s";
  }
}
