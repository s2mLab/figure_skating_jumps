import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/exceptions/abstract_ice_exception.dart';

/// Exception indicating that a value was empty or null when it shouldn't be
class EmptyFieldException implements AbstractIceException {
  @override
  String get devMessage {
    return "Given String is empty or null.";
  }

  @override
  String get uiMessage {
    return emptyFieldException;
  }
}
