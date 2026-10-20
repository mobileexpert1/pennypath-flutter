import '../../../../core/storage/key_value_store.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._store);

  static const _theme = 'settings.theme';
  static const _language = 'settings.language';
  static const _currency = 'settings.currency';
  static const _appLock = 'settings.appLock';

  final KeyValueStore _store;

  @override
  AppSettings load() {
    const defaults = AppSettings();
    final language = _store.getString(_language);
    final currency = _store.getString(_currency);
    return AppSettings(
      theme: ThemePreference.values.asNameMap()[_store.getString(_theme)] ?? defaults.theme,
      languageCode: AppSettings.supportedLanguages.contains(language) ? language : null,
      currencyCode: AppSettings.supportedCurrencies.contains(currency)
          ? currency!
          : defaults.currencyCode,
      appLockEnabled: _store.getBool(_appLock) ?? defaults.appLockEnabled,
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await _store.setString(_theme, settings.theme.name);
    final language = settings.languageCode;
    language == null ? await _store.remove(_language) : await _store.setString(_language, language);
    await _store.setString(_currency, settings.currencyCode);
    await _store.setBool(_appLock, value: settings.appLockEnabled);
  }
}
