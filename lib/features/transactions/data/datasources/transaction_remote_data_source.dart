import '../models/transaction_dto.dart';

/// Implement this to plug in another backend (Firebase, Supabase, GraphQL…).
abstract interface class TransactionRemoteDataSource {
  Future<List<TransactionDto>> fetchAll();

  /// Idempotent create-or-update keyed by the client-generated id.
  Future<void> upsert(TransactionDto transaction);

  /// Succeeds when the item is already gone.
  Future<void> delete(String id);
}
