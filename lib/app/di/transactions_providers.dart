import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../features/dashboard/domain/usecases/compute_dashboard_summary.dart';
import '../../features/transactions/data/datasources/mock/transaction_mock_data_source.dart';
import '../../features/transactions/data/datasources/transaction_local_data_source.dart';
import '../../features/transactions/data/datasources/transaction_remote_data_source.dart';
import '../../features/transactions/data/datasources/transaction_rest_data_source.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/domain/usecases/filter_transactions.dart';
import '../../features/transactions/domain/usecases/save_transaction.dart';
import 'auth_providers.dart';
import 'core_providers.dart';

final transactionRemoteDataSourceProvider = Provider<TransactionRemoteDataSource>(
  (ref) => switch (ref.watch(appConfigProvider).backend) {
    BackendMode.mock => TransactionMockDataSource(
      database: ref.watch(localDatabaseProvider),
      network: ref.watch(mockNetworkProvider),
      currentUserId: () async => (await ref.read(sessionStorageProvider).read())?.user.id,
    ),
    BackendMode.rest => TransactionRestDataSource(ref.watch(apiClientProvider)),
  },
);

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepositoryImpl(
    local: TransactionLocalDataSource(ref.watch(localDatabaseProvider)),
    remote: ref.watch(transactionRemoteDataSourceProvider),
    crashReporter: ref.watch(crashReporterProvider),
    clock: ref.watch(clockProvider),
  ),
);

final saveTransactionProvider = Provider<SaveTransaction>(
  (ref) => SaveTransaction(
    repository: ref.watch(transactionRepositoryProvider),
    analytics: ref.watch(analyticsProvider),
    clock: ref.watch(clockProvider),
    generateId: ref.watch(idGeneratorProvider),
  ),
);

final filterTransactionsProvider = Provider<FilterTransactions>((_) => const FilterTransactions());

final computeDashboardSummaryProvider = Provider<ComputeDashboardSummary>(
  (_) => const ComputeDashboardSummary(),
);
