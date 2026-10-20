import '../entities/transaction.dart';
import '../entities/transaction_filter.dart';

/// Applies search and type filters, then groups by calendar day (newest first).
class FilterTransactions {
  const FilterTransactions();

  List<TransactionGroup> call(List<Transaction> all, TransactionFilter filter) {
    final query = filter.query.trim().toLowerCase();
    final matches = all.where((t) {
      if (filter.type != null && t.type != filter.type) return false;
      if (query.isEmpty) return true;
      return t.title.toLowerCase().contains(query) ||
          (t.note?.toLowerCase().contains(query) ?? false);
    }).toList()..sort((a, b) => b.date.compareTo(a.date));

    final groups = <DateTime, List<Transaction>>{};
    for (final t in matches) {
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      (groups[day] ??= []).add(t);
    }
    return [
      for (final entry in groups.entries)
        TransactionGroup(day: entry.key, transactions: entry.value),
    ];
  }
}
