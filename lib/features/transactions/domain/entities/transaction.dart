import 'package:equatable/equatable.dart';

import 'transaction_category.dart';
import 'transaction_type.dart';

/// Amounts are stored in minor units (cents) to avoid floating point errors.
class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.type,
    required this.amountMinor,
    required this.title,
    required this.category,
    required this.date,
    required this.updatedAt,
    this.note,
  });

  final String id;
  final TransactionType type;
  final int amountMinor;
  final String title;
  final TransactionCategory category;
  final DateTime date;
  final DateTime updatedAt;
  final String? note;

  bool get isIncome => type == TransactionType.income;

  int get signedAmountMinor => isIncome ? amountMinor : -amountMinor;

  @override
  List<Object?> get props => [id, type, amountMinor, title, category, date, updatedAt, note];
}
