import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../providers/money_formatter_provider.dart';

/// Formats minor units in the user's currency; colours income and expenses.
class AmountText extends ConsumerWidget {
  const AmountText(
    this.amountMinor, {
    this.style,
    this.signed = false,
    this.colored = false,
    super.key,
  });

  final int amountMinor;
  final TextStyle? style;
  final bool signed;
  final bool colored;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = !colored || amountMinor == 0
        ? null
        : amountMinor > 0
        ? context.finance.income
        : context.finance.expense;
    return Text(
      ref.money(context).format(amountMinor, signed: signed),
      style: (style ?? const TextStyle()).copyWith(
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
