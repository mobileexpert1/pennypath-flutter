import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_tokens.dart';
import '../controllers/transactions_providers.dart';

/// Shown above every tab while the backend is unreachable.
class SyncStatusBanner extends ConsumerWidget {
  const SyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(syncStateProvider).value;
    final visible = state != null && state.isOffline;

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: !visible
          ? const SizedBox(width: double.infinity)
          : Semantics(
              liveRegion: true,
              child: Material(
                color: context.colors.tertiaryContainer,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cloud_off_rounded,
                          size: 18,
                          color: context.colors.onTertiaryContainer,
                        ),
                        const Gap(AppSpacing.sm),
                        Expanded(
                          child: Text(
                            context.l10n.syncOffline(state.pendingChanges),
                            style: context.text.bodySmall?.copyWith(
                              color: context.colors.onTertiaryContainer,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: context.l10n.retry,
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.refresh_rounded, size: 20),
                          color: context.colors.onTertiaryContainer,
                          onPressed: () => ref.read(transactionActionsProvider).sync(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
