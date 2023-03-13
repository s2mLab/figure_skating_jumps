import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/exceptions/ice_exception.dart';

class NullUserException implements IceException {
  @override
  String get devMessage {
    return "The referenced user is null.";
  }

  @override
  String get uiMessage {
    return nullUserException;
  }
}
