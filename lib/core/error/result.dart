import 'failure.dart';

sealed class Result<T> {
  const Result();

  R fold<R>(R Function(Failure failure) onFailure, R Function(T value) onSuccess) => switch (this) {
    Success(:final value) => onSuccess(value),
    Err(:final failure) => onFailure(failure),
  };

  bool get isSuccess => this is Success<T>;

  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Err() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Success() => null,
    Err(:final failure) => failure,
  };
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
