import '../../../../core/domain/user_data_store.dart';
import '../../../../core/error/result.dart';
import '../entities/sync_state.dart';
import '../entities/transaction.dart';

/// Offline-first: reads come from the device, writes sync in the background.
abstract interface class TransactionRepository implements UserDataStore {
  /// Newest first. Emits again on every local change.
  Stream<List<Transaction>> watchAll();

  Future<Transaction?> findById(String id);

  Future<Result<Transaction>> save(Transaction transaction);

  Future<Result<void>> delete(String id);

  Future<Result<void>> sync();

  Stream<SyncState> watchSyncState();
}
