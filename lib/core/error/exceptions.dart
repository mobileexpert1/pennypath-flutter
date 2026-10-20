/// Thrown by data sources. Repositories translate these into [Failure]s.
sealed class AppException implements Exception {
  const AppException([this.message]);

  final String? message;

  @override
  String toString() => '$runtimeType(${message ?? ''})';
}

class NetworkException extends AppException {
  const NetworkException([super.message]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message]);
}

class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException([super.message]);
}

class EmailInUseException extends AppException {
  const EmailInUseException([super.message]);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message]);
}

class ServerException extends AppException {
  const ServerException({this.statusCode, String? message}) : super(message);

  final int? statusCode;
}

class StorageException extends AppException {
  const StorageException([super.message]);
}
