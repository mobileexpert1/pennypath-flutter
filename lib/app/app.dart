import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../features/app_lock/presentation/widgets/app_lock_guard.dart';
import '../features/settings/presentation/controllers/settings_controller.dart';
import 'router/app_router.dart';

class PennypathApp extends ConsumerWidget {
  const PennypathApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      locale: ref.watch(localeProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => AppLockGuard(child: child ?? const SizedBox.shrink()),
    );
  }
}
