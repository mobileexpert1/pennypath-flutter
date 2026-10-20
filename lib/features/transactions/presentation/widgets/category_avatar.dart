import 'package:flutter/material.dart';

import '../../domain/entities/transaction_category.dart';
import '../category_style.dart';

class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar(this.category, {this.size = 44, super.key});

  final TransactionCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: category.color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(size / 3),
        ),
        child: Icon(category.icon, color: category.color, size: size * 0.5),
      ),
    );
  }
}
