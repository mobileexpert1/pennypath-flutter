import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import 'core_providers.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(ref.watch(keyValueStoreProvider)),
);
