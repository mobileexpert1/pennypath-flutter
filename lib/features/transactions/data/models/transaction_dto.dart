import '../../../../core/storage/local_database.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/entities/transaction_type.dart';

class TransactionDto {
  const TransactionDto({
    required this.id,
    required this.type,
    required this.amountMinor,
    required this.title,
    required this.category,
    required this.date,
    required this.updatedAt,
    this.note,
  });

  factory TransactionDto.fromJson(JsonMap json) => TransactionDto(
    id: json['id'] as String,
    type: json['type'] as String,
    amountMinor: (json['amountMinor'] as num).toInt(),
    title: json['title'] as String,
    category: json['category'] as String,
    date: DateTime.parse(json['date'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    note: json['note'] as String?,
  );

  factory TransactionDto.fromEntity(Transaction t) => TransactionDto(
    id: t.id,
    type: t.type.name,
    amountMinor: t.amountMinor,
    title: t.title,
    category: t.category.name,
    date: t.date,
    updatedAt: t.updatedAt,
    note: t.note,
  );

  final String id;
  final String type;
  final int amountMinor;
  final String title;
  final String category;
  final DateTime date;
  final DateTime updatedAt;
  final String? note;

  JsonMap toJson() => {
    'id': id,
    'type': type,
    'amountMinor': amountMinor,
    'title': title,
    'category': category,
    'date': date.toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    if (note != null) 'note': note,
  };

  /// Unknown enum values from a newer API fall back instead of crashing.
  Transaction toEntity() {
    final txType = TransactionType.values.asNameMap()[type] ?? TransactionType.expense;
    return Transaction(
      id: id,
      type: txType,
      amountMinor: amountMinor,
      title: title,
      category:
          TransactionCategory.values.asNameMap()[category] ??
          (txType == TransactionType.income
              ? TransactionCategory.otherIncome
              : TransactionCategory.otherExpense),
      date: date,
      updatedAt: updatedAt,
      note: note,
    );
  }
}
