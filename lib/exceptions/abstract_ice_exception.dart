/// Abstract class that has a [devMessage] to log and a [uiMessage] to show on the interface
abstract class AbstractIceException implements Exception {
  String get devMessage;
  String get uiMessage;
}
