import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/core_providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../transactions/presentation/controllers/transactions_providers.dart';
import '../../domain/entities/app_settings.dart';
import '../controllers/settings_controller.dart';
import '../widgets/profile_header.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _languageNames = {'en': 'English', 'es': 'Español', 'de': 'Deutsch'};

  String _themeLabel(AppLocalizations l10n, ThemePreference theme) => switch (theme) {
    ThemePreference.system => l10n.themeSystem,
    ThemePreference.light => l10n.themeLight,
    ThemePreference.dark => l10n.themeDark,
  };

  String _currencyLabel(BuildContext context, String code) =>
      '$code (${NumberFormat.simpleCurrency(locale: context.localeName, name: code).currencySymbol})';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          children: [
            const ProfileHeader(),
            SectionHeader(l10n.settingsAppearance),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: Text(l10n.settingsTheme),
              subtitle: Text(_themeLabel(l10n, settings.theme)),
              onTap: () async {
                final picked = await showChoiceSheet(
                  context,
                  title: l10n.settingsTheme,
                  options: ThemePreference.values,
                  selected: settings.theme,
                  labelOf: (t) => _themeLabel(l10n, t),
                );
                if (picked != null) await controller.setTheme(picked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.translate_rounded),
              title: Text(l10n.settingsLanguage),
              subtitle: Text(_languageNames[settings.languageCode] ?? l10n.languageSystem),
              onTap: () async {
                final picked = await showChoiceSheet<String>(
                  context,
                  title: l10n.settingsLanguage,
                  options: ['system', ...AppSettings.supportedLanguages],
                  selected: settings.languageCode ?? 'system',
                  labelOf: (code) => _languageNames[code] ?? l10n.languageSystem,
                );
                if (picked == null) return;
                await controller.setLanguage(picked == 'system' ? null : picked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: Text(l10n.settingsCurrency),
              subtitle: Text(_currencyLabel(context, settings.currencyCode)),
              onTap: () async {
                final picked = await showChoiceSheet(
                  context,
                  title: l10n.settingsCurrency,
                  options: AppSettings.supportedCurrencies,
                  selected: settings.currencyCode,
                  labelOf: (code) => _currencyLabel(context, code),
                );
                if (picked != null) await controller.setCurrency(picked);
              },
            ),
            SectionHeader(l10n.settingsSecurity),
            const _AppLockTile(),
            if (config.isMock) ...[
              SectionHeader(l10n.settingsDeveloper),
              SwitchListTile(
                secondary: const Icon(Icons.wifi_off_rounded),
                title: Text(l10n.settingsSimulateOffline),
                subtitle: Text(l10n.settingsSimulateOfflineSubtitle),
                value: ref.watch(simulateOfflineProvider),
                onChanged: (offline) {
                  ref.read(simulateOfflineProvider.notifier).toggle(offline: offline);
                  ref.read(transactionActionsProvider).sync();
                },
              ),
              const _SyncTile(),
            ],
            SectionHeader(l10n.settingsAbout),
            ListTile(
              leading: const Icon(Icons.dns_outlined),
              title: Text(l10n.settingsBackend),
              trailing: Text(config.backend.name.toUpperCase()),
            ),
            ListTile(
              leading: const Icon(Icons.layers_outlined),
              title: Text(l10n.settingsEnvironment),
              trailing: Text(config.environment),
            ),
            const Gap(AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: AppButton(
                label: l10n.signOut,
                icon: Icons.logout_rounded,
                variant: AppButtonVariant.outlined,
                expand: true,
                onPressed: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: l10n.signOutConfirmTitle,
                    message: l10n.signOutConfirmBody,
                    confirmLabel: l10n.signOut,
                    destructive: true,
                  );
                  if (confirmed) await ref.read(authControllerProvider.notifier).signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppLockTile extends ConsumerWidget {
  const _AppLockTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final enabled = ref.watch(settingsControllerProvider.select((s) => s.appLockEnabled));
    final available = ref.watch(biometricAvailableProvider).value ?? false;

    return SwitchListTile(
      secondary: const Icon(Icons.fingerprint_rounded),
      title: Text(l10n.settingsAppLock),
      subtitle: Text(available ? l10n.settingsAppLockSubtitle : l10n.settingsAppLockUnavailable),
      value: enabled,
      onChanged: available
          ? (value) => ref
                .read(settingsControllerProvider.notifier)
                .setAppLock(enabled: value, reason: l10n.enableLockReason)
          : null,
    );
  }
}

class _SyncTile extends ConsumerWidget {
  const _SyncTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sync = ref.watch(syncStateProvider).value;
    final last = sync?.lastSyncedAt;

    return ListTile(
      leading: const Icon(Icons.sync_rounded),
      title: Text(l10n.settingsSyncNow),
      subtitle: Text(
        last == null
            ? l10n.settingsNeverSynced
            : l10n.settingsLastSynced(DateFormat.Hms(context.localeName).format(last)),
      ),
      trailing: sync?.isSyncing ?? false
          ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : null,
      onTap: () => ref.read(transactionActionsProvider).sync(),
    );
  }
}
