import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/exceptions/abstract_ice_exception.dart';

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
