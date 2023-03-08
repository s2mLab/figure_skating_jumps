import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/exceptions/ice_exception.dart';

class ConflictException extends IceException {
  @override
  String get devMessage {
    return "The resource already exists";
  }

  @override
  String get uiMessage {
    return conflictException;
  }
}
