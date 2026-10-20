import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  /// Synchronous so the first frame already has the right theme and language.
  AppSettings load();

  Future<void> save(AppSettings settings);
}
