import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/core/network/auth_interceptor.dart';

/// Server that only accepts the token in [validToken].
class _FakeServer implements HttpClientAdapter {
  String validToken = 'fresh';
  final seenTokens = <String?>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? body,
    Future<void>? cancel,
  ) async {
    final header = options.headers['Authorization'] as String?;
    seenTokens.add(header);
    final ok = header == 'Bearer $validToken';
    return ResponseBody.fromString(
      jsonEncode({'ok': ok}),
      ok ? 200 : 401,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _Tokens implements AccessTokenProvider {
  _Tokens(this.current, {this.refreshed});

  String? current;
  final String? refreshed;
  int refreshCalls = 0;
  bool expired = false;

  @override
  Future<String?> accessToken() async => current;

  @override
  Future<String?> refreshAccessToken() async {
    refreshCalls++;
    current = refreshed;
    return refreshed;
  }

  @override
  void onSessionExpired() => expired = true;
}

Dio _client(_FakeServer server) =>
    Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = server;

void main() {
  late _FakeServer server;

  setUp(() => server = _FakeServer());

  Dio buildDio(_Tokens tokens) =>
      _client(server)
        ..interceptors.add(AuthInterceptor(tokens: tokens, retryClient: _client(server)));

  test('attaches the bearer token', () async {
    final tokens = _Tokens('fresh');
    final response = await buildDio(tokens).get<dynamic>('/me');

    expect(response.statusCode, 200);
    expect(server.seenTokens, ['Bearer fresh']);
    expect(tokens.refreshCalls, 0);
  });

  test('refreshes once on 401 and retries the request', () async {
    final tokens = _Tokens('stale', refreshed: 'fresh');
    final response = await buildDio(tokens).get<dynamic>('/me');

    expect(response.statusCode, 200);
    expect(server.seenTokens, ['Bearer stale', 'Bearer fresh']);
    expect(tokens.refreshCalls, 1);
  });

  test('concurrent 401s trigger a single refresh', () async {
    final tokens = _Tokens('stale', refreshed: 'fresh');
    final dio = buildDio(tokens);

    final responses = await Future.wait([dio.get<dynamic>('/a'), dio.get<dynamic>('/b')]);

    expect(responses.map((r) => r.statusCode), [200, 200]);
    expect(tokens.refreshCalls, 1);
  });

  test('expires the session when refresh fails', () async {
    final tokens = _Tokens('stale');

    await expectLater(
      buildDio(tokens).get<dynamic>('/me'),
      throwsA(isA<DioException>().having((e) => e.response?.statusCode, 'status', 401)),
    );
    expect(tokens.expired, isTrue);
  });
}
