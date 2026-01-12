/// Base exception class for app errors
abstract class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Authentication exception
class AuthException extends AppException {
  const AuthException(super.message);
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Server exception
class ServerException extends AppException {
  const ServerException(super.message);
}

/// Cache exception
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException(super.message);
}









