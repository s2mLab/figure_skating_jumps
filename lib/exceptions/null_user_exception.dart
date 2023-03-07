
class NullUserException implements Exception {
  late String message;

  NullUserException() {
    message = 'The referenced user is null.';
  }
}