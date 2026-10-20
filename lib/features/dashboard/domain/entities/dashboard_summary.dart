import 'package:equatable/equatable.dart';

import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_category.dart';

class CategorySpend extends Equatable {
  const CategorySpend({required this.category, required this.amountMinor, required this.share});

  final TransactionCategory category;
  final int amountMinor;

  /// 0..1 portion of the month's total spending.
  final double share;

  @override
  List<Object?> get props => [category, amountMinor, share];
}

class DashboardSummary extends Equatable {
  const DashboardSummary({
    required this.balanceMinor,
    required this.monthIncomeMinor,
    required this.monthExpenseMinor,
    required this.spendingByCategory,
    required this.recent,
  });

  final int balanceMinor;
  final int monthIncomeMinor;
  final int monthExpenseMinor;
  final List<CategorySpend> spendingByCategory;
  final List<Transaction> recent;

  bool get isEmpty => recent.isEmpty;

  @override
  List<Object?> get props => [
    balanceMinor,
    monthIncomeMinor,
    monthExpenseMinor,
    spendingByCategory,
    recent,
  ];
}
