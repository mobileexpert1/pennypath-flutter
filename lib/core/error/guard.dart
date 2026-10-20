import 'dart:async';

import '../services/crash_reporter.dart';
import 'exceptions.dart';
import 'failure.dart';
import 'result.dart';

/// Runs [action] and converts thrown [AppException]s into a [Result].
Future<Result<T>> guard<T>(Future<T> Function() action, {CrashReporter? reporter}) async {
  try {
    return Success(await action());
  } on AppException catch (e) {
    return Err(mapExceptionToFailure(e));
  } catch (e, stack) {
    unawaited(reporter?.recordError(e, stack));
    return const Err(UnexpectedFailure());
  }
}

Failure mapExceptionToFailure(AppException e) => switch (e) {
  NetworkException() => const NetworkFailure(),
  UnauthorizedException() => const UnauthorizedFailure(),
  InvalidCredentialsException() => const InvalidCredentialsFailure(),
  EmailInUseException() => const EmailInUseFailure(),
  NotFoundException() => const NotFoundFailure(),
  ServerException() => const ServerFailure(),
  StorageException() => const StorageFailure(),
};
