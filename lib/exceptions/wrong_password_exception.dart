import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/exceptions/abstract_ice_exception.dart';

/// Exception indicating the given password was wrong and the action was refused
class WrongPasswordException implements AbstractIceException {
  @override
  String get devMessage {
    return "Wrong password for user.";
  }

  @override
  String get uiMessage {
    return wrongPasswordException;
  }
}
