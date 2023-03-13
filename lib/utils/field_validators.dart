import '../constants/lang_fr.dart';

class FieldValidators {

  /// Validates a new name string and returns an error message if the validation fails.
  ///
  /// This function takes a [String] value and performs validation checks to ensure
  /// that the value is not null or empty, and that it does not exceed 255 characters.
  ///
  /// If the validation succeeds, this function returns `null`. If the validation fails,
  /// it returns a [String] error message describing the reason for the failure.
  ///
  /// This function is static, so it can be called directly on the class without
  /// creating an instance of the class.
  ///
  /// Returns a [String] error message if the validation fails, otherwise returns `null`.
  static String? newNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return pleaseFillField;
    }
    if (value.length > 255) {
      return reduceCharacter;
    }
    return null;
  }


  /// Validates a new email string and returns an error message if the validation fails.
  ///
  /// This function takes a [String] value and performs validation checks to ensure
  /// that the value is not null or empty, and that it is in a valid email format.
  ///
  /// If the validation succeeds, this function returns `null`. If the validation fails,
  /// it returns a [String] error message describing the reason for the failure.
  ///
  /// This function is static, so it can be called directly on the class without
  /// creating an instance of the class.
  ///
  /// Returns a [String] error message if the validation fails, otherwise returns `null`.
  static String? newEmailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return pleaseFillField;
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]+$').hasMatch(value)) {
      return invalidEmailFormat;
    }
    return null;
  }

  /// Validates a new password string and returns an error message if the validation fails.
  ///
  /// This function takes a [String] value and performs validation checks to ensure
  /// that the value is not null or empty, and that it contains at least 10 characters.
  ///
  /// If the validation succeeds, this function returns `null`. If the validation fails,
  /// it returns a [String] error message describing the reason for the failure.
  ///
  /// This function is static, so it can be called directly on the class without
  /// creating an instance of the class.
  ///
  /// Returns a [String] error message if the validation fails, otherwise returns `null`.
  static String? newPassValidator(String? value) {
    if (value == null || value.isEmpty) {
      return pleaseFillField;
    }
    if (value.length < 10) {
      return addCharacters;
    }
    return null;
  }

  /// Validates a new password confirmation string and returns an error message if the validation fails.
  ///
  /// This function takes two [String] values: a `value` to validate and a `password` to compare it against.
  /// It checks whether the `value` matches the `password` and returns an error message if they do not match.
  ///
  /// If the validation succeeds, this function returns `null`. If the validation fails,
  /// it returns a [String] error message describing the reason for the failure.
  ///
  /// This function is static, so it can be called directly on the class without
  /// creating an instance of the class.
  ///
  /// Returns a [String] error message if the validation fails, otherwise returns `null`.
  static String? newPassConfirmValidator(String? value, String? password) {
    return value == password ? null : passwordMismatch;
  }

  /// Validates a login email string and returns an error message if the validation fails.
  ///
  /// This function takes a [String] value and performs validation checks to ensure
  /// that the value is not null or empty.
  ///
  /// If the validation succeeds, this function returns `null`. If the validation fails,
  /// it returns a [String] error message describing the reason for the failure.
  ///
  /// This function is static, so it can be called directly on the class without
  /// creating an instance of the class.
  ///
  /// Returns a [String] error message if the validation fails, otherwise returns `null`.
  static String? loginEmailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return pleaseFillField;
    }
    return null;
  }

  /// Validates a login password string and returns an error message if the validation fails.
  /// The password string may start by or contain spaces (not trimmed).
  ///
  /// This function takes a [String] value and performs validation checks to ensure
  /// that the value is not null or empty.
  ///
  /// If the validation succeeds, this function returns `null`. If the validation fails,
  /// it returns a [String] error message describing the reason for the failure.
  ///
  /// This function is static, so it can be called directly on the class without
  /// creating an instance of the class.
  ///
  /// Returns a [String] error message if the validation fails, otherwise returns `null`.
  static String? loginPassValidator(String? value) {
    if (value == null || value.isEmpty) {
      return pleaseFillField;
    }
    return null;
  }
}