import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/finance_colors.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  FinanceColors get finance => Theme.of(this).extension<FinanceColors>()!;
  String get localeName => Localizations.localeOf(this).toString();
  bool get isWide => MediaQuery.sizeOf(this).width >= 840;

  void showSnack(String message, {String? actionLabel, VoidCallback? onAction}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: actionLabel == null || onAction == null
              ? null
              : SnackBarAction(label: actionLabel, onPressed: onAction),
        ),
      );
  }
}
