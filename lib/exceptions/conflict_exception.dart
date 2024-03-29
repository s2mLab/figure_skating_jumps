import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/exceptions/abstract_ice_exception.dart';

/// Exception indication a conflict in between two resources
class ConflictException extends AbstractIceException {
  @override
  String get devMessage {
    return "The resource already exists";
  }

  @override
  String get uiMessage {
    return conflictException;
  }
}
