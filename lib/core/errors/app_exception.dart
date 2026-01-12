import 'failures.dart';

class AppException implements Exception {
  AppException(this.failure);

  final Failure failure;

  String get message => failure.message;

  @override
  String toString() =>
      'AppException(${failure.runtimeType}): ${failure.message}';
}
