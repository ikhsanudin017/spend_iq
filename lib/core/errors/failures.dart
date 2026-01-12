abstract class Failure {
  Failure(this.message, [this.cause, this.stackTrace]);

  final String message;
  final Object? cause;
  final StackTrace? stackTrace;
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message, [super.cause, super.stackTrace]);
}

class CacheFailure extends Failure {
  CacheFailure(super.message, [super.cause, super.stackTrace]);
}

class ValidationFailure extends Failure {
  ValidationFailure(super.message, [super.cause, super.stackTrace]);
}
