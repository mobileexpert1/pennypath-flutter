import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/core_providers.dart';
import '../../../../app/di/transactions_providers.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/sync_state.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_filter.dart';
import '../../domain/entities/transaction_type.dart';

/// Rebuilt per user, and starts a sync whenever it is (re)created.
final transactionsProvider = StreamProvider<List<Transaction>>((ref) {
  ref.watch(authControllerProvider.select((auth) => auth.value?.id));
  final repository = ref.watch(transactionRepositoryProvider);
  unawaited(repository.sync());
  return repository.watchAll();
});

final syncStateProvider = StreamProvider<SyncState>(
  (ref) => ref.watch(transactionRepositoryProvider).watchSyncState(),
);

final transactionByIdProvider = Provider.family<Transaction?, String>(
  (ref, id) => ref.watch(transactionsProvider).value?.where((t) => t.id == id).firstOrNull,
);

final transactionFilterProvider = NotifierProvider<TransactionFilterController, TransactionFilter>(
  TransactionFilterController.new,
);

final transactionGroupsProvider = Provider<AsyncValue<List<TransactionGroup>>>((ref) {
  final filter = ref.watch(transactionFilterProvider);
  final apply = ref.watch(filterTransactionsProvider);
  return ref.watch(transactionsProvider).whenData((all) => apply(all, filter));
});

class TransactionFilterController extends Notifier<TransactionFilter> {
  @override
  TransactionFilter build() => const TransactionFilter();

  void setQuery(String query) => state = state.copyWith(query: query);

  void setType(TransactionType? type) => state = state.copyWith(type: () => type);

  void clear() => state = const TransactionFilter();
}

final transactionActionsProvider = Provider<TransactionActions>(TransactionActions.new);

/// Commands shared by the list (swipe) and the form screen.
class TransactionActions {
  const TransactionActions(this._ref);

  final Ref _ref;

  Future<Result<void>> delete(String id) async {
    final result = await _ref.read(transactionRepositoryProvider).delete(id);
    if (result.isSuccess) {
      await _ref.read(analyticsProvider).logEvent(AnalyticsEvent.transactionDeleted);
    }
    return result;
  }

  Future<Result<Transaction>> restore(Transaction transaction) =>
      _ref.read(transactionRepositoryProvider).save(transaction);

  Future<Result<void>> sync() => _ref.read(transactionRepositoryProvider).sync();
}
