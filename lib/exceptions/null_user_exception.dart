import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/exceptions/abstract_ice_exception.dart';

/// Exception indicating that the user was null when we tried to find it
class NullUserException implements AbstractIceException {
  @override
  String get devMessage {
    return "The referenced user is null.";
  }

  @override
  String get uiMessage {
    return nullUserException;
  }
}
