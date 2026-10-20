import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/network/auth_interceptor.dart';
import '../../features/auth/data/datasources/auth_mock_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_rest_data_source.dart';
import '../../features/auth/data/datasources/session_storage.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import 'core_providers.dart';
import 'transactions_providers.dart';

final sessionStorageProvider = Provider<SessionStorage>(
  (ref) => SessionStorage(ref.watch(secureStoreProvider)),
);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => switch (ref.watch(appConfigProvider).backend) {
    BackendMode.mock => AuthMockDataSource(
      database: ref.watch(localDatabaseProvider),
      network: ref.watch(mockNetworkProvider),
    ),
    BackendMode.rest => AuthRestDataSource(ref.watch(publicApiClientProvider)),
  },
);

final _authRepositoryImplProvider = Provider<AuthRepositoryImpl>(
  (ref) => AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    session: ref.watch(sessionStorageProvider),
    crashReporter: ref.watch(crashReporterProvider),
  ),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => ref.watch(_authRepositoryImplProvider),
);

final accessTokenProvider = Provider<AccessTokenProvider>(
  (ref) => ref.watch(_authRepositoryImplProvider),
);

final signOutProvider = Provider<SignOut>(
  (ref) => SignOut(
    auth: ref.watch(authRepositoryProvider),
    userData: [ref.watch(transactionRepositoryProvider)],
    analytics: ref.watch(analyticsProvider),
  ),
);
