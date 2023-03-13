import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/exceptions/ice_exception.dart';

class InvalidEmailException implements IceException {
  @override
  String get devMessage {
    return "The email was invalid.";
  }

  @override
  String get uiMessage {
    return invalidEmailException;
  }
}