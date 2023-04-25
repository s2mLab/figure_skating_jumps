import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/exceptions/abstract_ice_exception.dart';

/// Exception indicating a wrong email format or some other error with the email
class InvalidEmailException implements AbstractIceException {
  @override
  String get devMessage {
    return "The email was invalid.";
  }

  @override
  String get uiMessage {
    return invalidEmailException;
  }
}