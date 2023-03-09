import 'package:figure_skating_jumps/exceptions/null_user_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../exceptions/conflict_exception.dart';
import '../exceptions/invalid_email_exception.dart';
import '../exceptions/too_many_attempts_exception.dart';
import '../exceptions/weak_password_exception.dart';
import '../exceptions/wrong_password_exception.dart';

class ExceptionUtils {
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
