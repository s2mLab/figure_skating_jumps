class TimeConverter {
  /// Converts a given [DateTime] object to a string representing the hours and minutes in the format "hh:mm".
  ///
  /// Parameters:
  /// - [date]: the [DateTime] object to be converted.
  ///
  /// Return: A string representing the hours and minutes of the given [DateTime] object in the format "hh:mm".
  static String dateTimeToHoursAndMinutes(DateTime date) {
    return "${date.hour.toString().padLeft(2, "0")}h${date.minute.toString().padLeft(2, "0")}";
  }

  // Returns a string representation of the seconds component of a given [DateTime] object.
  ///
  /// Parameters:
  /// - [date]: The DateTime object to extract the seconds value from.
  ///
  /// Return: A string representation of the seconds component of [date], formatted with two digits padded with leading zeros.
  static String dateTimeToSeconds(DateTime date) {
    return "${date.second.toString().padLeft(2, "0")}s";
  }

  /// Convert milliseconds to a string with the format "X.YYYs", where X is the number of seconds and
  /// YYY is the remaining milliseconds.
  ///
  /// Parameters:
  /// - [ms]: The number of milliseconds to convert to a string.
  ///
  /// Return: A string with the format "X.YYYs" representing the given number of milliseconds.
  static String msToFormatSMs(int ms) {
    int nbSeconds = (ms / 1000).floor();
    ms -= nbSeconds * 1000;

    return "${nbSeconds.toString()}.${ms.toString().padLeft(3, "0")}s";
  }

  /// Converts a string representing seconds to milliseconds.
  ///
  /// Exceptions: This function may throw a FormatException if the input string cannot be parsed as a double.
  ///
  /// Parameters:
  /// - [value]: A string representing a duration in seconds.
  ///
  /// Return: An integer representing the duration in milliseconds.
  static int convertStringSecondsToMS(String value) {
    return (double.parse(value) * 1000).floor();
  }

  /// Convert milliseconds to a string representation of seconds.
  ///
  /// Parameters:
  /// - [ms]: An integer value representing milliseconds.
  ///
  /// Returns:
  /// - A string representation of seconds, with up to three decimal places.
  static String convertMsToStringSeconds(int ms) {
    return (ms.toDouble() / 1000).toString();
  }
}
