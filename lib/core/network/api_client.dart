import 'package:dio/dio.dart';

import 'dio_error_mapper.dart';

typedef Json = Map<String, dynamic>;

/// Thin wrapper over Dio so data sources only see JSON and [AppException]s.
class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<T> get<T>(String path, {Json? query}) =>
      _send(() => _dio.get<T>(path, queryParameters: query));

  Future<T> post<T>(String path, {Object? body}) => _send(() => _dio.post<T>(path, data: body));

  Future<T> put<T>(String path, {Object? body}) => _send(() => _dio.put<T>(path, data: body));

  Future<void> delete(String path) => _send(() => _dio.delete<void>(path));

  Future<T> _send<T>(Future<Response<T>> Function() request) async {
    try {
      final response = await request();
      return response.data as T;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
