class TimeConverter {
  /// Formats a [DateTime] value as a string in hours and minutes format.
  ///
  /// This function takes a [DateTime] value and returns a formatted string in the form "HHhMM".
  ///
  /// Returns a [String] value representing the formatted date.
  static String dateTimeToHoursAndMinutes(DateTime date) {
    return "${date.hour.toString().padLeft(2, "0")}h${date.minute.toString().padLeft(2, "0")}";
  }

  /// Formats a [DateTime] value as a string with seconds.
  ///
  /// This function takes a [DateTime] value and returns a string with the seconds value, formatted to always include
  /// two digits, padded with leading zeros if necessary.
  ///
  /// Returns a [String] value representing the formatted seconds.
  static String dateTimeToSeconds(DateTime date) {
    return "${date.second.toString().padLeft(2, "0")}s";
  }

  /// Formats a duration in milliseconds as a string with seconds and milliseconds.
  ///
  /// This function takes an [int] value representing the duration in milliseconds.
  ///
  /// Returns a [String] value representing the formatted duration.
  static String msToFormatSMs(int ms) {
    int nbSeconds = (ms / 1000).floor();
    ms -= nbSeconds * 1000;

    return "${nbSeconds.toString()}.${ms.toString().padLeft(3, "0")}s";
  }

  /// Converts a string value representing seconds to an integer value in milliseconds.
  ///
  /// This function takes a [String] value, parses it to a [double] value and multiplies it
  /// by 1000 to convert it to milliseconds. The result is then returned as an [int] value
  /// after being rounded down to the nearest integer.
  ///
  /// Returns an [int] value representing the time in milliseconds.
  static int convertStringSecondsToMS(String value) {
    return (double.parse(value) * 1000).floor();
  }

  /// Converts a duration in milliseconds to a string representing the duration in seconds.
  ///
  /// This function takes an [int] value representing a duration in milliseconds,
  /// and returns a [String] value representing the same duration in seconds.
  ///
  /// Returns a [String] value representing the duration in seconds, with three decimal places.
  static String convertMsToStringSeconds(int ms) {
    return (ms.toDouble() / 1000).toString();
  }
}
