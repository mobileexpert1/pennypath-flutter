import 'package:pennypath/features/transactions/domain/entities/transaction.dart';
import 'package:pennypath/features/transactions/domain/entities/transaction_category.dart';

Transaction buildTransaction({
  String id = 'tx-1',
  TransactionCategory category = TransactionCategory.food,
  int amountMinor = 1250,
  String title = 'Lunch',
  DateTime? date,
  DateTime? updatedAt,
  String? note,
}) => Transaction(
  id: id,
  type: category.type,
  amountMinor: amountMinor,
  title: title,
  category: category,
  date: date ?? DateTime(2026, 10, 15, 12),
  updatedAt: updatedAt ?? DateTime.utc(2026, 10, 15, 12),
  note: note,
);
