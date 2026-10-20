import 'package:dio/dio.dart';

/// Implemented by the auth feature so the network layer stays auth-agnostic.
abstract interface class AccessTokenProvider {
  Future<String?> accessToken();

  /// Returns a fresh access token, or null when the session cannot be renewed.
  Future<String?> refreshAccessToken();

  void onSessionExpired();
}

/// Attaches the bearer token and transparently refreshes it once on 401.
/// [QueuedInterceptor] serialises requests so only one refresh runs at a time.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required this.tokens, required this.retryClient});

  static const _retriedKey = 'auth_retried';

  final AccessTokenProvider tokens;
  final Dio retryClient;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokens.accessToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    if (err.response?.statusCode != 401 || request.extra[_retriedKey] == true) {
      return handler.next(err);
    }

    final usedToken = request.headers['Authorization'];
    final current = await tokens.accessToken();
    final token = current != null && 'Bearer $current' != usedToken
        ? current
        : await tokens.refreshAccessToken();

    if (token == null) {
      tokens.onSessionExpired();
      return handler.next(err);
    }

    request
      ..headers['Authorization'] = 'Bearer $token'
      ..extra[_retriedKey] = true;
    try {
      handler.resolve(await retryClient.fetch<dynamic>(request));
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}
