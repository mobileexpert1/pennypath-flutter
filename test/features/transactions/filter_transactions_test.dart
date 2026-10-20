import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/features/transactions/domain/entities/transaction_category.dart';
import 'package:pennypath/features/transactions/domain/entities/transaction_filter.dart';
import 'package:pennypath/features/transactions/domain/entities/transaction_type.dart';
import 'package:pennypath/features/transactions/domain/usecases/filter_transactions.dart';

import '../../helpers/builders.dart';

void main() {
  const filter = FilterTransactions();
  final all = [
    buildTransaction(id: 'a', title: 'Coffee', date: DateTime(2026, 10, 18, 8)),
    buildTransaction(
      id: 'b',
      title: 'Salary',
      category: TransactionCategory.salary,
      amountMinor: 500000,
      date: DateTime(2026, 10, 18, 9),
    ),
    buildTransaction(
      id: 'c',
      title: 'Dinner',
      note: 'with coffee after',
      date: DateTime(2026, 10, 19),
    ),
  ];

  test('groups by day, newest first, with a net total per day', () {
    final groups = filter(all, const TransactionFilter());

    expect(groups.map((g) => g.day), [DateTime(2026, 10, 19), DateTime(2026, 10, 18)]);
    expect(groups.last.transactions.map((t) => t.id), ['b', 'a']);
    expect(groups.last.netMinor, 500000 - 1250);
  });

  test('searches title and note, case-insensitively', () {
    final groups = filter(all, const TransactionFilter(query: '  COFFEE '));
    expect(groups.expand((g) => g.transactions).map((t) => t.id), ['c', 'a']);
  });

  test('filters by type', () {
    final groups = filter(all, const TransactionFilter(type: TransactionType.income));
    expect(groups.expand((g) => g.transactions).map((t) => t.id), ['b']);
  });
}
