import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../domain/entities/transaction_type.dart';
import '../controllers/transactions_providers.dart';

class TransactionFilterBar extends ConsumerStatefulWidget {
  const TransactionFilterBar({super.key});

  @override
  ConsumerState<TransactionFilterBar> createState() => _TransactionFilterBarState();
}

class _TransactionFilterBarState extends ConsumerState<TransactionFilterBar> {
  late final _search = TextEditingController(text: ref.read(transactionFilterProvider).query);
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 250),
      () => ref.read(transactionFilterProvider.notifier).setQuery(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final type = ref.watch(transactionFilterProvider.select((f) => f.type));

    ref.listen(transactionFilterProvider.select((f) => f.query), (_, query) {
      if (query.isEmpty && _search.text.isNotEmpty) _search.clear();
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
      child: Column(
        children: [
          SearchBar(
            controller: _search,
            hintText: l10n.searchHint,
            leading: const Icon(Icons.search_rounded),
            elevation: const WidgetStatePropertyAll(0),
            onChanged: _onQueryChanged,
            trailing: [
              ListenableBuilder(
                listenable: _search,
                builder: (context, _) => _search.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        tooltip: l10n.clearFilters,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _search.clear();
                          _onQueryChanged('');
                        },
                      ),
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<TransactionType?>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: null, label: Text(l10n.filterAll)),
                ButtonSegment(value: TransactionType.income, label: Text(l10n.typeIncome)),
                ButtonSegment(value: TransactionType.expense, label: Text(l10n.typeExpense)),
              ],
              selected: {type},
              onSelectionChanged: (selection) =>
                  ref.read(transactionFilterProvider.notifier).setType(selection.first),
            ),
          ),
        ],
      ),
    );
  }
}
