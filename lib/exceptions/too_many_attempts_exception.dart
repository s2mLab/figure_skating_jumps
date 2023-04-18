import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/exceptions/abstract_ice_exception.dart';

/// Exception indicating there were too many attempts in a short amount of time
/// requiring the server to refuse further ones for some time
class TooManyAttemptsException implements AbstractIceException {
  @override
  String get devMessage {
    return "We have blocked all requests from this device due to unusual activity.";
  }

  @override
  String get uiMessage {
    return tooManyAttemptsException;
  }
}
