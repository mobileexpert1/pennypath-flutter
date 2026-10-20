import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/features/dashboard/domain/usecases/compute_dashboard_summary.dart';
import 'package:pennypath/features/transactions/domain/entities/transaction_category.dart';

import '../../helpers/builders.dart';

void main() {
  final now = DateTime(2026, 10, 20);

  test('balance is all-time while income and expenses are this month only', () {
    final summary = const ComputeDashboardSummary()([
      buildTransaction(
        id: '1',
        category: TransactionCategory.salary,
        amountMinor: 300000,
        date: DateTime(2026, 9, 2),
      ),
      buildTransaction(
        id: '2',
        category: TransactionCategory.salary,
        amountMinor: 300000,
        date: DateTime(2026, 10, 2),
      ),
      buildTransaction(
        id: '3',
        category: TransactionCategory.housing,
        amountMinor: 100000,
        date: DateTime(2026, 10, 3),
      ),
      buildTransaction(id: '4', amountMinor: 50000, date: DateTime(2026, 9, 3)),
    ], now);

    expect(summary.balanceMinor, 300000 + 300000 - 100000 - 50000);
    expect(summary.monthIncomeMinor, 300000);
    expect(summary.monthExpenseMinor, 100000);
    expect(summary.recent.first.id, '3');
  });

  test('ranks categories by spend and merges the tail into "other"', () {
    final amounts = {
      TransactionCategory.housing: 5000,
      TransactionCategory.food: 4000,
      TransactionCategory.groceries: 3000,
      TransactionCategory.transport: 2000,
      TransactionCategory.health: 1000,
      TransactionCategory.travel: 600,
      TransactionCategory.shopping: 400,
    };
    final summary = const ComputeDashboardSummary(maxCategories: 3)([
      for (final MapEntry(key: category, value: amount) in amounts.entries)
        buildTransaction(id: category.name, category: category, amountMinor: amount, date: now),
    ], now);

    expect(summary.spendingByCategory.map((s) => s.category), [
      TransactionCategory.housing,
      TransactionCategory.food,
      TransactionCategory.groceries,
      TransactionCategory.otherExpense,
    ]);
    expect(summary.spendingByCategory.last.amountMinor, 4000);
    expect(summary.spendingByCategory.fold<double>(0, (sum, s) => sum + s.share), closeTo(1, 1e-9));
  });

  test('handles no data', () {
    final summary = const ComputeDashboardSummary()([], now);
    expect(summary.isEmpty, isTrue);
    expect(summary.spendingByCategory, isEmpty);
  });
}
