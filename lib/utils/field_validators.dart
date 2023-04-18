import 'package:figure_skating_jumps/constants/lang_fr.dart';

class FieldValidators {
  /// Validates a given [value] for use as a name, returning an error message if the validation fails.
  ///
  /// Parameters:
  /// - [value]: The value to validate.
  ///
  /// Return:
  /// - A [String] or `null` indicating whether the [value] is valid.
  ///     - If [value] is `null` or empty, returns a [String] with the message "Please fill out this field".
  ///     - If [value] length is greater than 255 characters, returns a [String] with the message "Please reduce character length to 255 or less".
  ///     - If [value] is valid, returns `null`.
  static String? newNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return pleaseFillField;
    }
    if (value.length > 255) {
      return reduceCharacterLabel;
    }
    return null;
  }

  /// Validates a given [value] for use as an email address, returning an error message if the validation fails.
  ///
  /// Parameters:
  /// - [value]: The value to validate.
  ///
  /// Return:
  /// - A [String] or `null` indicating whether the [value] is valid.
  ///     - If [value] is `null` or empty, returns a [String] with the message "Please fill out this field".
  ///     - If [value] is not in the format of a valid email address, returns a [String] with the message "Please enter a valid email address".
  ///     - If [value] is valid, returns `null`.
  static String? newEmailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return pleaseFillField;
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]+$').hasMatch(value)) {
      return invalidEmailFormatLabel;
    }
    return null;
  }

  /// Validates a given [value] for use as a double, returning an error message if the validation fails.
  ///
  /// Parameters:
  /// - [value]: The value to validate.
  ///
  /// Return:
  /// - A [String] or `null` indicating whether the [value] is valid.
  ///     - If [value] is `null` or empty, returns a [String] with the message "Please fill out this field".
  ///     - If [value] is not in the format of a valid double, returns a [String] with the message "Please enter a valid number".
  ///     - If [value] is valid, returns `null`.
  static String? doubleValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return pleaseFillField;
    }
    if (!RegExp(r'^(0|[1-9]\d*)(\.\d+)?$').hasMatch(value)) {
      return invalidDigitFormatLabel;
    }
    return null;
  }

  /// Validates the provided password string.
  ///
  /// Parameters:
  /// - [value]: The password string to validate.
  ///
  /// Return:
  /// - Null if the provided string is a valid password; otherwise, a string with an error message describing the problem with the input.
  static String? newPassValidator(String? value) {
    if (value == null || value.isEmpty) {
      return pleaseFillField;
    }
    if (value.length < 10) {
      return addCharactersLabel;
    }
    return null;
  }

  /// Validates the provided confirmation password string, ensuring that it matches the password provided.
  ///
  /// Parameters:
  /// - [value]: The confirmation password string to validate.
  /// - [password]: The original password to match against.
  ///
  /// Return:
  /// - Null if the confirmation password matches the original password; otherwise, a string with an error message describing the problem with the input.
  static String? newPassConfirmValidator(String? value, String? password) {
    return value == password ? null : passwordMismatchLabel;
  }

  /// Validates a login email string and returns an error message if the validation fails.
  ///
  /// Exceptions:
  /// - Returns [pleaseFillField] if the email value is null or empty after trimming.
  ///
  /// Parameters:
  /// - [value]: The email value to validate.
  ///
  /// Return:
  /// - Null if the email value is valid, otherwise a String with an error message.
  static String? loginEmailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return pleaseFillField;
    }
    return null;
  }

  /// This function is used to validate the user login password input.
  ///
  /// Parameters:
  /// - [value]: The value of the password input field as a string.
  ///
  /// Return:
  /// - If the input is not null or empty, return null.
  /// - If the input is null or empty, return a string with an error message.
  static String? loginPassValidator(String? value) {
    if (value == null || value.isEmpty) {
      return pleaseFillField;
    }
    return null;
  }
}
