import 'dart:async';
import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/guard.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/crash_reporter.dart';
import '../../domain/entities/sync_state.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_data_source.dart';
import '../datasources/transaction_remote_data_source.dart';
import '../models/transaction_dto.dart';

/// Writes land locally first and are queued; [sync] pushes the queue and
/// then pulls the server state. Local pending changes always win on pull.
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl({
    required this._local,
    required this._remote,
    required this._crashReporter,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final TransactionLocalDataSource _local;
  final TransactionRemoteDataSource _remote;
  final CrashReporter _crashReporter;
  final DateTime Function() _clock;

  final _syncStates = StreamController<SyncState>.broadcast();
  SyncState _syncState = const SyncState();
  Future<Result<void>>? _inFlight;

  @override
  Stream<List<Transaction>> watchAll() => _local.watchAll().map(
    (records) =>
        records
            .where((r) => r.status != SyncStatus.pendingDelete)
            .map((r) => r.transaction.toEntity())
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date)),
  );

  @override
  Future<Transaction?> findById(String id) async {
    final record = await _local.get(id);
    return record == null || record.status == SyncStatus.pendingDelete
        ? null
        : record.transaction.toEntity();
  }

  @override
  Future<Result<Transaction>> save(Transaction transaction) async {
    final result = await guard(() async {
      await _local.put(
        LocalTransactionRecord(TransactionDto.fromEntity(transaction), SyncStatus.pendingUpsert),
      );
      return transaction;
    }, reporter: _crashReporter);
    if (result.isSuccess) _syncInBackground();
    return result;
  }

  @override
  Future<Result<void>> delete(String id) async {
    final result = await guard<void>(() async {
      final record = await _local.get(id);
      if (record == null) throw const NotFoundException();
      await _local.put(LocalTransactionRecord(record.transaction, SyncStatus.pendingDelete));
    }, reporter: _crashReporter);
    if (result.isSuccess) _syncInBackground();
    return result;
  }

  @override
  Future<Result<void>> sync() => _inFlight ??= _sync().whenComplete(() => _inFlight = null);

  @override
  Stream<SyncState> watchSyncState() async* {
    yield _syncState;
    yield* _syncStates.stream;
  }

  @override
  Future<void> flush() async => sync();

  @override
  Future<void> clearUserData() async {
    await _local.clear();
    _emit(const SyncState());
  }

  void _syncInBackground() => unawaited(sync());

  Future<Result<void>> _sync() async {
    _emit(_syncState.copyWith(isSyncing: true));
    final result = await guard<void>(() async {
      await _pushPending();
      await _pull();
    }, reporter: _crashReporter);
    final pending = await _pendingCount();
    _emit(
      SyncState(
        isOffline: result.failureOrNull is NetworkFailure,
        pendingChanges: pending,
        lastSyncedAt: result.isSuccess ? _clock() : _syncState.lastSyncedAt,
      ),
    );
    return result;
  }

  /// Connectivity errors abort the push; any other error leaves that item
  /// queued for the next sync so one bad record cannot block the rest.
  Future<void> _pushPending() async {
    for (final record in await _local.getAll()) {
      if (!record.isPending) continue;
      try {
        await _push(record);
      } on NetworkException {
        rethrow;
      } on UnauthorizedException {
        rethrow;
      } on AppException catch (e, stack) {
        await _crashReporter.recordError(e, stack);
      }
    }
  }

  Future<void> _push(LocalTransactionRecord record) async {
    final id = record.transaction.id;
    if (record.status == SyncStatus.pendingDelete) {
      await _remote.delete(id);
      if ((await _local.get(id))?.status == SyncStatus.pendingDelete) await _local.remove(id);
    } else {
      await _remote.upsert(record.transaction);
      await _markSyncedIfUnchanged(record);
    }
  }

  /// Skips the update if the user edited the item while it was uploading.
  Future<void> _markSyncedIfUnchanged(LocalTransactionRecord pushed) async {
    final current = await _local.get(pushed.transaction.id);
    if (current == null ||
        current.status != SyncStatus.pendingUpsert ||
        current.transaction.updatedAt != pushed.transaction.updatedAt) {
      return;
    }
    await _local.put(LocalTransactionRecord(pushed.transaction, SyncStatus.synced));
  }

  Future<void> _pull() async {
    final remote = {for (final dto in await _remote.fetchAll()) dto.id: dto};
    final local = {for (final r in await _local.getAll()) r.transaction.id: r};

    for (final dto in remote.values) {
      final existing = local[dto.id];
      if (existing != null && (existing.isPending || _sameContent(existing.transaction, dto))) {
        continue;
      }
      await _local.put(LocalTransactionRecord(dto, SyncStatus.synced));
    }
    for (final record in local.values) {
      if (!record.isPending && !remote.containsKey(record.transaction.id)) {
        await _local.remove(record.transaction.id);
      }
    }
  }

  bool _sameContent(TransactionDto a, TransactionDto b) =>
      jsonEncode(a.toJson()) == jsonEncode(b.toJson());

  Future<int> _pendingCount() async {
    try {
      return (await _local.getAll()).where((r) => r.isPending).length;
    } on Exception {
      return _syncState.pendingChanges;
    }
  }

  void _emit(SyncState state) {
    _syncState = state;
    _syncStates.add(state);
  }
}
