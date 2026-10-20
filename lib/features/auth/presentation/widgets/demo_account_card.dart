import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';

class DemoAccountCard extends StatelessWidget {
  const DemoAccountCard({required this.onUseDemo, super.key});

  final VoidCallback onUseDemo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.secondaryContainer,
      child: Padding(
        padding: AppSpacing.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science_outlined, color: context.colors.onSecondaryContainer),
                const Gap(AppSpacing.sm),
                Text(
                  context.l10n.authDemoTitle,
                  style: context.text.titleMedium?.copyWith(
                    color: context.colors.onSecondaryContainer,
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.sm),
            Text(
              context.l10n.authDemoBody,
              style: context.text.bodyMedium?.copyWith(color: context.colors.onSecondaryContainer),
            ),
            const Gap(AppSpacing.sm),
            AppButton(
              label: context.l10n.authUseDemo,
              icon: Icons.bolt_rounded,
              variant: AppButtonVariant.text,
              onPressed: onUseDemo,
            ),
          ],
        ),
      ),
    );
  }
}
