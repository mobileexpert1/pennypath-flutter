import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:pennypath/features/settings/domain/entities/app_settings.dart';

import '../../helpers/fakes.dart';

void main() {
  test('returns defaults when nothing is stored', () {
    expect(SettingsRepositoryImpl(InMemoryKeyValueStore()).load(), const AppSettings());
  });

  test('round-trips every setting', () async {
    final repository = SettingsRepositoryImpl(InMemoryKeyValueStore());
    const settings = AppSettings(
      theme: ThemePreference.dark,
      languageCode: 'de',
      currencyCode: 'EUR',
      appLockEnabled: true,
    );

    await repository.save(settings);

    expect(repository.load(), settings);
  });

  test('ignores corrupted or unsupported stored values', () {
    final store = InMemoryKeyValueStore()
      ..values.addAll({
        'settings.theme': 'neon',
        'settings.language': 'xx',
        'settings.currency': 'BTC',
      });
    expect(SettingsRepositoryImpl(store).load(), const AppSettings());
  });
}
