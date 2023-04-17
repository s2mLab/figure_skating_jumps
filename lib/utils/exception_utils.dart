import 'package:figure_skating_jumps/exceptions/conflict_exception.dart';
import 'package:figure_skating_jumps/exceptions/invalid_email_exception.dart';
import 'package:figure_skating_jumps/exceptions/null_user_exception.dart';
import 'package:figure_skating_jumps/exceptions/too_many_attempts_exception.dart';
import 'package:figure_skating_jumps/exceptions/weak_password_exception.dart';
import 'package:figure_skating_jumps/exceptions/wrong_password_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExceptionUtils {
  /// Handles a [FirebaseAuthException] and throws the corresponding exception.
  ///
  /// This function takes a [FirebaseAuthException] object and uses its [code] property
  /// to determine which exception to throw.
  ///
  /// Throws a specific exception according to the Firebase authentication error code received.
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
