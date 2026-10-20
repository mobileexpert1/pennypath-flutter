import 'package:equatable/equatable.dart';

/// Errors the presentation layer is allowed to know about.
sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure();
}

class EmailInUseFailure extends Failure {
  const EmailInUseFailure();
}

class NotFoundFailure extends Failure {
  const NotFoundFailure();
}

class ServerFailure extends Failure {
  const ServerFailure();
}

class StorageFailure extends Failure {
  const StorageFailure();
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure();
}

/// Field-level validation errors, keyed by an error code enum.
class ValidationFailure<E extends Enum> extends Failure {
  const ValidationFailure(this.errors);

  final Map<String, E> errors;

  @override
  List<Object?> get props => [errors];
}
