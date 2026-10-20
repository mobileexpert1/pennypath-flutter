import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/app_lock_controller.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  Future<void> _unlock() =>
      ref.read(appLockControllerProvider.notifier).unlock(context.l10n.lockReason);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_rounded, size: 64, color: context.colors.primary),
                const Gap(AppSpacing.lg),
                Text(
                  l10n.lockTitle,
                  style: context.text.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const Gap(AppSpacing.sm),
                Text(l10n.lockBody, textAlign: TextAlign.center),
                const Gap(AppSpacing.xl),
                AppButton(
                  label: l10n.lockUnlock,
                  icon: Icons.fingerprint_rounded,
                  onPressed: _unlock,
                ),
                const Gap(AppSpacing.sm),
                AppButton(
                  label: l10n.signOut,
                  variant: AppButtonVariant.text,
                  onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
