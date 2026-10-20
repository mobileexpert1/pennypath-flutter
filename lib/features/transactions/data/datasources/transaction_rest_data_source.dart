import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/transaction_dto.dart';
import 'transaction_remote_data_source.dart';

class TransactionRestDataSource implements TransactionRemoteDataSource {
  const TransactionRestDataSource(this._api, {this.pageSize = 200});

  final ApiClient _api;
  final int pageSize;

  /// Follows `nextCursor` until the server has no more pages.
  @override
  Future<List<TransactionDto>> fetchAll() async {
    final items = <TransactionDto>[];
    String? cursor;
    do {
      final page = await _api.get<Json>(
        '/transactions',
        query: {'limit': pageSize, 'cursor': ?cursor},
      );
      items.addAll((page['items'] as List<dynamic>).cast<Json>().map(TransactionDto.fromJson));
      cursor = page['nextCursor'] as String?;
    } while (cursor != null);
    return items;
  }

  @override
  Future<void> upsert(TransactionDto transaction) =>
      _api.put<void>('/transactions/${transaction.id}', body: transaction.toJson());

  @override
  Future<void> delete(String id) async {
    try {
      await _api.delete('/transactions/$id');
    } on NotFoundException {
      return;
    }
  }
}
