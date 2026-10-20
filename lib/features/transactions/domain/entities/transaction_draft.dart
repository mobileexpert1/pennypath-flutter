import 'transaction_category.dart';
import 'transaction_type.dart';

/// Unvalidated form input. A null [id] means a new transaction.
class TransactionDraft {
  const TransactionDraft({
    required this.type,
    required this.amountMinor,
    required this.title,
    required this.category,
    required this.date,
    this.id,
    this.note,
  });

  final String? id;
  final TransactionType type;
  final int? amountMinor;
  final String title;
  final TransactionCategory category;
  final DateTime date;
  final String? note;
}
