import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/core/error/exceptions.dart';
import 'package:pennypath/core/error/failure.dart';
import 'package:pennypath/core/error/guard.dart';
import 'package:pennypath/core/error/result.dart';

import '../helpers/fakes.dart';

void main() {
  test('returns Success with the value', () async {
    final result = await guard(() async => 42);
    expect(result.valueOrNull, 42);
  });

  test('maps AppExceptions to the matching Failure', () async {
    final cases = <AppException, Failure>{
      const NetworkException(): const NetworkFailure(),
      const UnauthorizedException(): const UnauthorizedFailure(),
      const InvalidCredentialsException(): const InvalidCredentialsFailure(),
      const EmailInUseException(): const EmailInUseFailure(),
      const NotFoundException(): const NotFoundFailure(),
      const ServerException(statusCode: 500): const ServerFailure(),
      const StorageException(): const StorageFailure(),
    };
    for (final MapEntry(key: exception, value: failure) in cases.entries) {
      final result = await guard<void>(() async => throw exception);
      expect(result.failureOrNull, failure);
    }
  });

  test('reports unknown errors and hides details from the UI', () async {
    final reporter = SilentCrashReporter();
    final result = await guard<void>(() async => throw StateError('boom'), reporter: reporter);

    expect(result, isA<Err<void>>());
    expect(result.failureOrNull, const UnexpectedFailure());
    expect(reporter.errors.single, isA<StateError>());
  });
}
