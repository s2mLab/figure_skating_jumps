import 'package:figure_skating_jumps/exceptions/conflict_exception.dart';
import 'package:figure_skating_jumps/exceptions/invalid_email_exception.dart';
import 'package:figure_skating_jumps/exceptions/null_user_exception.dart';
import 'package:figure_skating_jumps/exceptions/too_many_attempts_exception.dart';
import 'package:figure_skating_jumps/exceptions/weak_password_exception.dart';
import 'package:figure_skating_jumps/exceptions/wrong_password_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExceptionUtils {
  /// Handles a [FirebaseAuthException] by mapping its error code to a custom exception type and throwing it.
  ///
  /// Exceptions:
  /// - Throws an instance of [AbstractIceException].
  ///
  /// Parameters:
  /// - [e]: The [FirebaseAuthException] to handle.
  static handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case "email-already-in-use":
        throw ConflictException();
      case "invalid-email":
        throw InvalidEmailException();
      case "weak-password":
        throw WeakPasswordException();
      case "user-not-found":
        throw NullUserException();
      case "wrong-password":
        throw WrongPasswordException();
      case "too-many-requests":
        throw TooManyAttemptsException();
    }
  }
}
