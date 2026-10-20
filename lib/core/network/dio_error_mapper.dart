import 'package:dio/dio.dart';

import '../error/exceptions.dart';

AppException mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkException();
    case DioExceptionType.badCertificate:
      return const NetworkException('Certificate rejected');
    case DioExceptionType.badResponse:
      return switch (e.response?.statusCode) {
        401 || 403 => const UnauthorizedException(),
        404 => const NotFoundException(),
        409 => const EmailInUseException(),
        final code => ServerException(statusCode: code),
      };
    case DioExceptionType.transformTimeout:
      return const NetworkException();
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return e.error is AppException ? e.error! as AppException : const NetworkException();
  }
}
