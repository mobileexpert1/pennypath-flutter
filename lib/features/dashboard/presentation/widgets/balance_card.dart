import 'package:flutter/material.dart';

import '../../../../app/widgets/amount_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../domain/entities/dashboard_summary.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({required this.summary, super.key});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, Color.lerp(colors.primary, colors.tertiary, 0.6)!],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.dashboardBalance,
            style: context.text.titleSmall?.copyWith(
              color: colors.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          const Gap(AppSpacing.xs),
          AmountText(
            summary.balanceMinor,
            style: context.text.displaySmall?.copyWith(color: colors.onPrimary),
          ),
          const Gap(AppSpacing.lg),
          Text(
            context.l10n.dashboardThisMonth,
            style: context.text.labelMedium?.copyWith(
              color: colors.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          const Gap(AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  icon: Icons.arrow_downward_rounded,
                  label: context.l10n.typeIncome,
                  amountMinor: summary.monthIncomeMinor,
                ),
              ),
              const Gap(AppSpacing.md),
              Expanded(
                child: _Stat(
                  icon: Icons.arrow_upward_rounded,
                  label: context.l10n.typeExpense,
                  amountMinor: summary.monthExpenseMinor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label, required this.amountMinor});

  final IconData icon;
  final String label;
  final int amountMinor;

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colors.onPrimary;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: onPrimary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, color: onPrimary, size: 20),
          const Gap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.text.labelSmall?.copyWith(color: onPrimary)),
                AmountText(amountMinor, style: context.text.titleSmall?.copyWith(color: onPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
