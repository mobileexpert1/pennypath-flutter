import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../services/app_logger.dart';
import 'certificate_pinning.dart';

Dio createDio(AppConfig config, AppLogger logger) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
    ),
  );
  final pinned = createPinnedAdapter(config.certificatePins);
  if (pinned != null) dio.httpClientAdapter = pinned;
  if (kDebugMode) dio.interceptors.add(_SafeLogInterceptor(logger));
  return dio;
}

/// Logs method, path and status only. Headers and bodies may hold secrets.
class _SafeLogInterceptor extends Interceptor {
  _SafeLogInterceptor(this._logger);

  final AppLogger _logger;

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final r = response.requestOptions;
    _logger.debug('${r.method} ${r.path} -> ${response.statusCode}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final r = err.requestOptions;
    _logger.warning('${r.method} ${r.path} -> ${err.response?.statusCode ?? err.type.name}');
    handler.next(err);
  }
}
