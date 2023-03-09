import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/exceptions/ice_exception.dart';

class WrongPasswordException implements IceException {
  @override
  String get devMessage {
    return "Wrong password for user.";
  }

  @override
  String get uiMessage {
    return wrongPasswordException;
  }
}
