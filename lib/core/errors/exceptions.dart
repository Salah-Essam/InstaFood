/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  AppException(this.message, {this.code});
  
  @override
  String toString() => message;
}

/// Exception thrown when required fields are empty or invalid
class FieldRequiredException extends AppException {
  final String fieldName;
  
  FieldRequiredException(this.fieldName) 
      : super('$fieldName is required and cannot be empty');
}

/// Exception thrown for authentication-related errors
class AuthException extends AppException {
  AuthException(super.message, {super.code});
}

/// Exception thrown for invalid credentials during sign-in
class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException() : super('Wrong email or password.');
}

/// Exception thrown when user is not found
class UserNotFoundException extends AuthException {
  UserNotFoundException() : super('Wrong email or password.');
}

/// Exception thrown for network-related errors
class NetworkException extends AppException {
  NetworkException(super.message);
}

/// Exception thrown for server-related errors
class ServerException extends AppException {
  ServerException(super.message, {super.code});
}

/// Exception thrown when user already exists
class UserAlreadyExistsException extends AuthException {
  UserAlreadyExistsException() : super('User with this email already exists.');
}

/// Exception thrown for weak passwords
class WeakPasswordException extends AuthException {
  WeakPasswordException() : super('Password is too weak. Please choose a stronger password.');
}

/// Exception thrown for invalid email format
class InvalidEmailException extends AuthException {
  InvalidEmailException() : super('Invalid email format.');
}