import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/core_providers.dart';
import '../../../../app/di/settings_providers.dart';
import '../../domain/entities/app_settings.dart';

final settingsControllerProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

final themeModeProvider = Provider<ThemeMode>(
  (ref) => switch (ref.watch(settingsControllerProvider.select((s) => s.theme))) {
    ThemePreference.system => ThemeMode.system,
    ThemePreference.light => ThemeMode.light,
    ThemePreference.dark => ThemeMode.dark,
  },
);

final localeProvider = Provider<Locale?>((ref) {
  final code = ref.watch(settingsControllerProvider.select((s) => s.languageCode));
  return code == null ? null : Locale(code);
});

final biometricAvailableProvider = FutureProvider<bool>(
  (ref) => ref.watch(biometricServiceProvider).isAvailable(),
);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).load();

  Future<void> setTheme(ThemePreference theme) => _update(state.copyWith(theme: theme));

  Future<void> setLanguage(String? code) => _update(state.copyWith(languageCode: () => code));

  Future<void> setCurrency(String code) => _update(state.copyWith(currencyCode: code));

  /// Turning the lock on requires a successful authentication first.
  Future<bool> setAppLock({required bool enabled, required String reason}) async {
    if (enabled) {
      final biometrics = ref.read(biometricServiceProvider);
      if (!await biometrics.isAvailable() || !await biometrics.authenticate(reason)) {
        return false;
      }
    }
    await _update(state.copyWith(appLockEnabled: enabled));
    return true;
  }

  Future<void> _update(AppSettings next) async {
    state = next;
    await ref.read(settingsRepositoryProvider).save(next);
  }
}
