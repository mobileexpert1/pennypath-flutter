import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/money_formatter_provider.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../transactions/presentation/category_style.dart';
import '../../domain/entities/dashboard_summary.dart';

class SpendingChart extends ConsumerWidget {
  const SpendingChart({required this.summary, super.key});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spending = summary.spendingByCategory;
    final money = ref.money(context);
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: spending.isEmpty
            ? Text(l10n.dashboardNoSpending, style: context.text.bodyMedium)
            : Row(
                children: [
                  SizedBox.square(
                    dimension: 132,
                    child: Semantics(
                      label: [
                        for (final s in spending)
                          '${s.category.label(l10n)} ${money.format(s.amountMinor)}',
                      ].join(', '),
                      child: ExcludeSemantics(
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 38,
                            sections: [
                              for (final s in spending)
                                PieChartSectionData(
                                  value: s.amountMinor.toDouble(),
                                  color: s.category.color,
                                  radius: 22,
                                  showTitle: false,
                                ),
                            ],
                          ),
                          duration: const Duration(milliseconds: 400),
                        ),
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.lg),
                  Expanded(
                    child: ExcludeSemantics(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final s in spending)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: s.category.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const Gap(AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      s.category.label(l10n),
                                      style: context.text.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '${(s.share * 100).round()}%',
                                    style: context.text.labelMedium,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
