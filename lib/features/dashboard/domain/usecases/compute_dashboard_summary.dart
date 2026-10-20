import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_category.dart';
import '../entities/dashboard_summary.dart';

class ComputeDashboardSummary {
  const ComputeDashboardSummary({this.recentCount = 5, this.maxCategories = 5});

  final int recentCount;

  /// Smaller categories are merged into "other" to keep the chart readable.
  final int maxCategories;

  DashboardSummary call(List<Transaction> transactions, DateTime now) {
    var balance = 0;
    var income = 0;
    var expense = 0;
    final byCategory = <TransactionCategory, int>{};

    for (final t in transactions) {
      balance += t.signedAmountMinor;
      if (t.date.year != now.year || t.date.month != now.month) continue;
      if (t.isIncome) {
        income += t.amountMinor;
      } else {
        expense += t.amountMinor;
        byCategory.update(t.category, (v) => v + t.amountMinor, ifAbsent: () => t.amountMinor);
      }
    }

    final sorted = byCategory.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(maxCategories).toList();
    final rest = sorted.skip(maxCategories).fold(0, (sum, e) => sum + e.value);
    if (rest > 0) {
      final other = top.indexWhere((e) => e.key == TransactionCategory.otherExpense);
      if (other >= 0) {
        top[other] = MapEntry(TransactionCategory.otherExpense, top[other].value + rest);
      } else {
        top.add(MapEntry(TransactionCategory.otherExpense, rest));
      }
    }

    final recent = [...transactions]..sort((a, b) => b.date.compareTo(a.date));
    return DashboardSummary(
      balanceMinor: balance,
      monthIncomeMinor: income,
      monthExpenseMinor: expense,
      spendingByCategory: [
        for (final e in top)
          CategorySpend(
            category: e.key,
            amountMinor: e.value,
            share: expense == 0 ? 0 : e.value / expense,
          ),
      ],
      recent: recent.take(recentCount).toList(),
    );
  }
}
