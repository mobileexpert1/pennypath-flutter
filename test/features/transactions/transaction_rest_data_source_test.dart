import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/core/error/exceptions.dart';
import 'package:pennypath/core/network/api_client.dart';
import 'package:pennypath/features/transactions/data/datasources/transaction_rest_data_source.dart';
import 'package:pennypath/features/transactions/data/models/transaction_dto.dart';

import '../../helpers/builders.dart';

/// Serves `/transactions` in pages of [pageSize] and records each request.
class _PagedServer implements HttpClientAdapter {
  _PagedServer(this.total);

  final int total;
  final requests = <Uri>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? body,
    Future<void>? cancel,
  ) async {
    requests.add(options.uri);
    if (options.method == 'DELETE') return ResponseBody.fromString('', 404);
    final limit = options.queryParameters['limit'] as int;
    final start = int.parse(options.queryParameters['cursor'] as String? ?? '0');
    final end = (start + limit).clamp(0, total);
    final page = {
      'items': [
        for (var i = start; i < end; i++)
          TransactionDto.fromEntity(buildTransaction(id: 'tx-$i')).toJson(),
      ],
      'nextCursor': end < total ? '$end' : null,
    };
    return ResponseBody.fromString(
      jsonEncode(page),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

TransactionRestDataSource _source(_PagedServer server) => TransactionRestDataSource(
  ApiClient(Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = server),
  pageSize: 2,
);

void main() {
  test('fetchAll follows the cursor through every page', () async {
    final server = _PagedServer(5);

    final items = await _source(server).fetchAll();

    expect(items.map((t) => t.id), ['tx-0', 'tx-1', 'tx-2', 'tx-3', 'tx-4']);
    expect(server.requests, hasLength(3));
    expect(server.requests.first.queryParameters.containsKey('cursor'), isFalse);
  });

  test('deleting an item that is already gone succeeds', () async {
    await expectLater(_source(_PagedServer(0)).delete('missing'), completes);
  });

  test('maps HTTP errors to typed exceptions', () async {
    final source = TransactionRestDataSource(
      ApiClient(
        Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = _ErrorServer(500),
      ),
    );
    await expectLater(source.fetchAll(), throwsA(isA<ServerException>()));
  });
}

class _ErrorServer implements HttpClientAdapter {
  _ErrorServer(this.status);

  final int status;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? body,
    Future<void>? cancel,
  ) async => ResponseBody.fromString('{}', status);

  @override
  void close({bool force = false}) {}
}
