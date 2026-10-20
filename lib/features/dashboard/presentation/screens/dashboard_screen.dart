import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_view.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../transactions/presentation/controllers/transactions_providers.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';
import '../controllers/dashboard_providers.dart';
import '../widgets/balance_card.dart';
import '../widgets/spending_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final name = ref.watch(authControllerProvider).value?.name ?? '';
    final summary = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardGreeting(name.split(' ').first))),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        tooltip: l10n.addTransaction,
        onPressed: () => context.push(Routes.newTransaction),
        child: const Icon(Icons.add_rounded),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(transactionActionsProvider).sync(),
        child: AsyncValueView(
          value: summary,
          onRetry: () => ref.invalidate(transactionsProvider),
          data: (summary) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              ResponsiveBody(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: AppSpacing.screen,
                      child: BalanceCard(summary: summary),
                    ),
                    if (summary.isEmpty)
                      StatusView(
                        icon: Icons.receipt_long_outlined,
                        title: l10n.emptyTitle,
                        message: l10n.emptyBody,
                        actionLabel: l10n.addTransaction,
                        onAction: () => context.push(Routes.newTransaction),
                      )
                    else ...[
                      SectionHeader(l10n.dashboardSpending),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: SpendingChart(summary: summary),
                      ),
                      SectionHeader(
                        l10n.dashboardRecent,
                        trailing: TextButton(
                          onPressed: () => context.go(Routes.transactions),
                          child: Text(l10n.seeAll),
                        ),
                      ),
                      for (final t in summary.recent)
                        TransactionTile(
                          transaction: t,
                          showDate: true,
                          onTap: () => context.push(Routes.editTransaction(t.id)),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
