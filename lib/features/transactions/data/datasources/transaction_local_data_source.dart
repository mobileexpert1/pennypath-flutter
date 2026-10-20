import 'dart:async';

import '../../../../core/storage/local_database.dart';
import '../models/transaction_dto.dart';

enum SyncStatus { synced, pendingUpsert, pendingDelete }

class LocalTransactionRecord {
  const LocalTransactionRecord(this.transaction, this.status);

  factory LocalTransactionRecord.fromJson(JsonMap json) => LocalTransactionRecord(
    TransactionDto.fromJson(json['data'] as JsonMap),
    SyncStatus.values.byName(json['status'] as String),
  );

  final TransactionDto transaction;
  final SyncStatus status;

  bool get isPending => status != SyncStatus.synced;

  JsonMap toJson() => {'data': transaction.toJson(), 'status': status.name};
}

/// The on-device source of truth, including the queue of unsynced changes.
class TransactionLocalDataSource {
  TransactionLocalDataSource(this._database);

  static const _collectionName = 'transactions';

  final LocalDatabase _database;

  Future<LocalCollection> get _collection => _database.collection(_collectionName);

  Future<List<LocalTransactionRecord>> getAll() async =>
      (await (await _collection).getAll()).map(LocalTransactionRecord.fromJson).toList();

  Future<LocalTransactionRecord?> get(String id) async {
    final json = await (await _collection).get(id);
    return json == null ? null : LocalTransactionRecord.fromJson(json);
  }

  Future<void> put(LocalTransactionRecord record) async =>
      (await _collection).put(record.transaction.id, record.toJson());

  Future<void> remove(String id) async => (await _collection).delete(id);

  Future<void> clear() async => (await _collection).clear();

  /// Subscribes to changes before the first read so no write is missed,
  /// and chains reads so emissions stay in order.
  Stream<List<LocalTransactionRecord>> watchAll() {
    StreamSubscription<void>? changes;
    var queue = Future<void>.value();
    late final StreamController<List<LocalTransactionRecord>> controller;

    void refresh() => queue = queue.then((_) async {
      try {
        final records = await getAll();
        if (!controller.isClosed) controller.add(records);
      } on Exception catch (e, stack) {
        controller.addError(e, stack);
      }
    });

    controller = StreamController(
      onListen: () async {
        try {
          changes = (await _collection).watch().listen((_) => refresh());
          refresh();
        } on Exception catch (e, stack) {
          controller.addError(e, stack);
        }
      },
      onCancel: () => changes?.cancel(),
    );
    return controller.stream;
  }
}
