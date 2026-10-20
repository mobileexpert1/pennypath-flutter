import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/core_providers.dart';
import '../../../../app/router/routes.dart';
import '../../../../app/widgets/amount_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_mappers.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_view.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_filter.dart';
import '../controllers/transactions_providers.dart';
import '../day_label.dart';
import '../widgets/transaction_filter_bar.dart';
import '../widgets/transaction_tile.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(transactionGroupsProvider);
    final filter = ref.watch(transactionFilterProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navTransactions)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => context.push(Routes.newTransaction),
        icon: const Icon(Icons.add_rounded),
        label: Text(context.l10n.addTransaction),
      ),
      body: ResponsiveBody(
        child: Column(
          children: [
            const TransactionFilterBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(transactionActionsProvider).sync(),
                child: AsyncValueView(
                  value: groups,
                  onRetry: () => ref.invalidate(transactionsProvider),
                  data: (groups) =>
                      groups.isEmpty ? _EmptyList(filter: filter) : _GroupedList(groups: groups),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupedList extends ConsumerWidget {
  const _GroupedList({required this.groups});

  final List<TransactionGroup> groups;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider)();
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              dayLabel(context, group.day, now),
              trailing: AmountText(
                group.netMinor,
                signed: true,
                style: context.text.labelMedium?.copyWith(color: context.colors.onSurfaceVariant),
              ),
            ),
            for (final transaction in group.transactions)
              _DismissibleTile(transaction: transaction),
          ],
        );
      },
    );
  }
}

class _DismissibleTile extends ConsumerWidget {
  const _DismissibleTile({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(transactionActionsProvider);
    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: context.colors.errorContainer,
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: AppSpacing.lg),
        child: Icon(Icons.delete_outline_rounded, color: context.colors.onErrorContainer),
      ),
      confirmDismiss: (_) async {
        final result = await actions.delete(transaction.id);
        if (!context.mounted) return false;
        result.fold(
          (failure) => context.showSnack(failure.message(context.l10n)),
          (_) => context.showSnack(
            context.l10n.transactionDeleted,
            actionLabel: context.l10n.undo,
            onAction: () => actions.restore(transaction),
          ),
        );
        return result.isSuccess;
      },
      child: TransactionTile(
        transaction: transaction,
        onTap: () => context.push(Routes.editTransaction(transaction.id)),
      ),
    );
  }
}

class _EmptyList extends ConsumerWidget {
  const _EmptyList({required this.filter});

  final TransactionFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Scrollable so pull-to-refresh still works on an empty list.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: constraints.maxHeight,
          child: filter.isActive
              ? StatusView(
                  icon: Icons.search_off_rounded,
                  title: l10n.noResultsTitle,
                  message: l10n.noResultsBody,
                  actionLabel: l10n.clearFilters,
                  onAction: ref.read(transactionFilterProvider.notifier).clear,
                )
              : StatusView(
                  icon: Icons.receipt_long_outlined,
                  title: l10n.emptyTitle,
                  message: l10n.emptyBody,
                ),
        ),
      ),
    );
  }
}
