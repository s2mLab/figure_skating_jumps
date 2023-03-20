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

    return "$time${nbSeconds.toString()}sec";
  }
}
