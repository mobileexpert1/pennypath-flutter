import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypath/core/error/exceptions.dart';
import 'package:pennypath/core/error/failure.dart';
import 'package:pennypath/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:pennypath/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:pennypath/features/transactions/data/models/transaction_dto.dart';
import 'package:pennypath/features/transactions/data/repositories/transaction_repository_impl.dart';

import '../../helpers/builders.dart';
import '../../helpers/fakes.dart';

class _MockRemote extends Mock implements TransactionRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late TransactionLocalDataSource local;
  late TransactionRepositoryImpl repository;
  late List<TransactionDto> server;

  setUpAll(() => registerFallbackValue(TransactionDto.fromEntity(buildTransaction())));

  void goOnline() {
    when(() => remote.fetchAll()).thenAnswer((_) async => List.of(server));
    when(() => remote.upsert(any())).thenAnswer((call) async {
      final dto = call.positionalArguments.first as TransactionDto;
      server
        ..removeWhere((t) => t.id == dto.id)
        ..add(dto);
    });
    when(
      () => remote.delete(any()),
    ).thenAnswer((call) async => server.removeWhere((t) => t.id == call.positionalArguments.first));
  }

  void goOffline() {
    when(() => remote.fetchAll()).thenThrow(const NetworkException());
    when(() => remote.upsert(any())).thenThrow(const NetworkException());
    when(() => remote.delete(any())).thenThrow(const NetworkException());
  }

  setUp(() {
    remote = _MockRemote();
    local = TransactionLocalDataSource(InMemoryLocalDatabase());
    repository = TransactionRepositoryImpl(
      local: local,
      remote: remote,
      crashReporter: SilentCrashReporter(),
      clock: () => DateTime(2026, 10, 20),
    );
    server = [];
    goOnline();
  });

  test('save is visible immediately, then synced to the server', () async {
    final tx = buildTransaction();
    final emitted = expectLater(repository.watchAll(), emitsThrough([tx]));

    await repository.save(tx);
    await emitted;
    await repository.sync();

    expect(server.single.id, tx.id);
    expect((await local.get(tx.id))!.status, SyncStatus.synced);
  });

  test('offline writes stay queued and are pushed when back online', () async {
    goOffline();
    await repository.save(buildTransaction());
    final offlineResult = await repository.sync();

    expect(offlineResult.failureOrNull, const NetworkFailure());
    final state = await repository.watchSyncState().first;
    expect(state.isOffline, isTrue);
    expect(state.pendingChanges, 1);
    expect((await local.get('tx-1'))!.status, SyncStatus.pendingUpsert);

    goOnline();
    expect((await repository.sync()).isSuccess, isTrue);
    expect(server.map((t) => t.id), ['tx-1']);
    expect((await repository.watchSyncState().first).pendingChanges, 0);
  });

  test('a rejected item stays queued without blocking the pull', () async {
    await repository.save(buildTransaction(id: 'local-only'));
    await repository.sync();
    server
      ..clear()
      ..add(TransactionDto.fromEntity(buildTransaction(id: 'from-other-device')));

    when(() => remote.upsert(any())).thenThrow(const ServerException(statusCode: 500));
    await repository.save(buildTransaction(id: 'pending', title: 'Rejected for now'));
    await repository.sync();

    expect((await local.get('pending'))!.status, SyncStatus.pendingUpsert);

    final ids = (await repository.watchAll().first).map((t) => t.id);
    expect(ids, unorderedEquals(['from-other-device', 'pending']));
  });

  test('delete hides the item at once and removes it after sync', () async {
    await repository.save(buildTransaction());
    await repository.sync();

    await repository.delete('tx-1');

    expect(await repository.findById('tx-1'), isNull);
    await repository.sync();
    expect(server, isEmpty);
    expect(await local.get('tx-1'), isNull);
  });

  test('clearUserData wipes the local store', () async {
    await repository.save(buildTransaction());
    await repository.clearUserData();
    expect(await local.getAll(), isEmpty);
  });
}
