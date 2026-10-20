import 'package:equatable/equatable.dart';

enum ThemePreference { system, light, dark }

class AppSettings extends Equatable {
  const AppSettings({
    this.theme = ThemePreference.system,
    this.languageCode,
    this.currencyCode = 'USD',
    this.appLockEnabled = false,
  });

  static const supportedLanguages = ['en', 'es', 'de'];
  static const supportedCurrencies = ['USD', 'EUR', 'GBP', 'INR'];

  final ThemePreference theme;

  /// Null follows the device language.
  final String? languageCode;
  final String currencyCode;
  final bool appLockEnabled;

  AppSettings copyWith({
    ThemePreference? theme,
    String? Function()? languageCode,
    String? currencyCode,
    bool? appLockEnabled,
  }) => AppSettings(
    theme: theme ?? this.theme,
    languageCode: languageCode != null ? languageCode() : this.languageCode,
    currencyCode: currencyCode ?? this.currencyCode,
    appLockEnabled: appLockEnabled ?? this.appLockEnabled,
  );

  @override
  List<Object?> get props => [theme, languageCode, currencyCode, appLockEnabled];
}
