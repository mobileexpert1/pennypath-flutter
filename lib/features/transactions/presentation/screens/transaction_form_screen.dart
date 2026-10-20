import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/core_providers.dart';
import '../../../../app/di/transactions_providers.dart';
import '../../../../app/providers/money_formatter_provider.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_mappers.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/utils/money_input_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../core/widgets/status_view.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/transaction_rules.dart';
import '../controllers/transactions_providers.dart';
import '../widgets/category_picker.dart';

/// Creates a transaction, or edits one when [transactionId] is given.
class TransactionFormScreen extends ConsumerWidget {
  const TransactionFormScreen({this.transactionId, super.key});

  final String? transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = transactionId;
    if (id == null) return const _TransactionForm();

    final loaded = ref.watch(transactionsProvider).hasValue;
    final existing = ref.watch(transactionByIdProvider(id));
    if (existing != null) return _TransactionForm(initial: existing);
    return Scaffold(
      appBar: AppBar(),
      body: loaded
          ? StatusView.failure(context, const NotFoundFailure())
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _TransactionForm extends ConsumerStatefulWidget {
  const _TransactionForm({this.initial});

  final Transaction? initial;

  @override
  ConsumerState<_TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends ConsumerState<_TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  late final _amount = TextEditingController();
  late final _title = TextEditingController(text: widget.initial?.title);
  late final _note = TextEditingController(text: widget.initial?.note);
  late TransactionType _type = widget.initial?.type ?? TransactionType.expense;
  late TransactionCategory _category =
      widget.initial?.category ?? TransactionCategory.defaultFor(_type);
  late DateTime _date = widget.initial?.date ?? ref.read(clockProvider)();
  bool _saving = false;

  bool get _isEditing => widget.initial != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final initial = widget.initial;
    if (initial != null && _amount.text.isEmpty) {
      _amount.text = ref.readMoney(context).toInput(initial.amountMinor);
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  void _setType(TransactionType type) => setState(() {
    _type = type;
    if (_category.type != type) _category = TransactionCategory.defaultFor(type);
  });

  Future<void> _pickDate() async {
    final now = ref.read(clockProvider)();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked != null) {
      setState(
        () => _date = DateTime(picked.year, picked.month, picked.day, _date.hour, _date.minute),
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final result = await ref
        .read(saveTransactionProvider)
        .call(
          TransactionDraft(
            id: widget.initial?.id,
            type: _type,
            amountMinor: MoneyFormatter.parse(_amount.text),
            title: _title.text,
            category: _category,
            date: _date,
            note: _note.text,
          ),
        );
    if (!mounted) return;
    setState(() => _saving = false);
    _finish(result, context.l10n.transactionSaved);
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.deleteConfirmTitle,
      message: l10n.deleteConfirmBody,
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final result = await ref.read(transactionActionsProvider).delete(widget.initial!.id);
    if (mounted) _finish(result, l10n.transactionDeleted);
  }

  void _finish(Result<Object?> result, String successMessage) {
    final l10n = context.l10n;
    switch (result) {
      case Success():
        context.showSnack(successMessage);
        context.pop();
      case Err(failure: ValidationFailure<TransactionFieldError>(:final errors)):
        context.showSnack(errors.values.first.message(l10n));
      case Err(:final failure):
        context.showSnack(failure.message(l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final money = ref.money(context);
    String? message(TransactionFieldError? error) => error?.message(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.formEditTitle : l10n.formNewTitle),
        actions: [
          if (_isEditing)
            IconButton(
              tooltip: l10n.delete,
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: _saving ? null : _delete,
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.screen,
          child: ResponsiveBody(
            child: AppButton(label: l10n.save, onPressed: _save, isLoading: _saving, expand: true),
          ),
        ),
      ),
      body: SafeArea(
        child: ResponsiveBody(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: AppSpacing.screen,
              children: [
                SegmentedButton<TransactionType>(
                  segments: [
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: Text(l10n.typeExpense),
                      icon: const Icon(Icons.arrow_upward_rounded),
                    ),
                    ButtonSegment(
                      value: TransactionType.income,
                      label: Text(l10n.typeIncome),
                      icon: const Icon(Icons.arrow_downward_rounded),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (s) => _setType(s.first),
                ),
                const Gap(AppSpacing.lg),
                AppTextField(
                  label: l10n.formAmount,
                  controller: _amount,
                  prefixText: '${money.symbol} ',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [MoneyInputFormatter()],
                  style: context.text.headlineSmall,
                  validator: (v) => message(TransactionRules.amount(MoneyFormatter.parse(v ?? ''))),
                ),
                const Gap(AppSpacing.md),
                AppTextField(
                  label: l10n.formTitle,
                  hint: l10n.formTitleHint,
                  controller: _title,
                  maxLength: TransactionRules.maxTitleLength,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  validator: (v) => message(TransactionRules.title(v ?? '')),
                ),
                const Gap(AppSpacing.lg),
                Text(l10n.formCategory, style: context.text.titleSmall),
                const Gap(AppSpacing.sm),
                CategoryPicker(
                  type: _type,
                  selected: _category,
                  onSelected: (c) => setState(() => _category = c),
                ),
                const Gap(AppSpacing.lg),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: Text(l10n.formDate),
                  subtitle: Text(DateFormat.yMMMMEEEEd(context.localeName).format(_date)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: _pickDate,
                ),
                const Gap(AppSpacing.md),
                AppTextField(
                  label: l10n.formNote,
                  controller: _note,
                  maxLines: 3,
                  maxLength: TransactionRules.maxNoteLength,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) => message(TransactionRules.note(v)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
