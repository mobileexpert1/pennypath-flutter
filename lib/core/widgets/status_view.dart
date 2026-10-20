import 'package:flutter/material.dart';

import '../error/failure.dart';
import '../extensions/context_extensions.dart';
import '../l10n/l10n_mappers.dart';
import '../theme/app_tokens.dart';
import 'app_button.dart';

/// Shared layout for empty, error and informational states.
class StatusView extends StatelessWidget {
  const StatusView({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  factory StatusView.failure(BuildContext context, Object error, {VoidCallback? onRetry}) {
    final failure = error is Failure ? error : const UnexpectedFailure();
    return StatusView(
      icon: failure is NetworkFailure ? Icons.cloud_off_rounded : Icons.error_outline_rounded,
      title: failure.message(context.l10n),
      actionLabel: onRetry == null ? null : context.l10n.retry,
      onAction: onRetry,
    );
  }

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: context.colors.primaryContainer,
              child: Icon(icon, size: 36, color: context.colors.onPrimaryContainer),
            ),
            const Gap(AppSpacing.md),
            Text(title, style: context.text.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const Gap(AppSpacing.sm),
              Text(
                message!,
                style: context.text.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const Gap(AppSpacing.lg),
              AppButton(label: actionLabel!, onPressed: onAction, variant: AppButtonVariant.tonal),
            ],
          ],
        ),
      ),
    );
  }
}
