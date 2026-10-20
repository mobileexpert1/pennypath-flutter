import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/entities/transaction_type.dart';
import '../category_style.dart';

class CategoryPicker extends StatelessWidget {
  const CategoryPicker({
    required this.type,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final TransactionType type;
  final TransactionCategory selected;
  final ValueChanged<TransactionCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final category in TransactionCategory.forType(type))
          ChoiceChip(
            avatar: Icon(category.icon, color: category.color, size: 18),
            label: Text(category.label(context.l10n)),
            selected: category == selected,
            showCheckmark: false,
            onSelected: (_) => onSelected(category),
          ),
      ],
    );
  }
}
