
class NullUserException implements Exception {
  late String message;

  NullUserException() {
    message = 'The signed in user is null';
  }
}