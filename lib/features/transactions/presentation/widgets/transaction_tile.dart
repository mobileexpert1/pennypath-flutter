import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/widgets/amount_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/transaction.dart';
import '../category_style.dart';
import 'category_avatar.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({required this.transaction, this.onTap, this.showDate = false, super.key});

  final Transaction transaction;
  final VoidCallback? onTap;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final category = transaction.category.label(context.l10n);
    final subtitle = showDate
        ? '$category · ${DateFormat.MMMd(context.localeName).format(transaction.date)}'
        : category;

    return ListTile(
      onTap: onTap,
      leading: CategoryAvatar(transaction.category),
      title: Text(transaction.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: AmountText(
        transaction.signedAmountMinor,
        signed: true,
        colored: transaction.isIncome,
        style: context.text.titleSmall,
      ),
    );
  }
}
