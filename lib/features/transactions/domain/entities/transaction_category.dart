import 'transaction_type.dart';

enum TransactionCategory {
  salary(TransactionType.income),
  freelance(TransactionType.income),
  investment(TransactionType.income),
  gift(TransactionType.income),
  otherIncome(TransactionType.income),
  food(TransactionType.expense),
  groceries(TransactionType.expense),
  transport(TransactionType.expense),
  shopping(TransactionType.expense),
  housing(TransactionType.expense),
  utilities(TransactionType.expense),
  entertainment(TransactionType.expense),
  health(TransactionType.expense),
  travel(TransactionType.expense),
  otherExpense(TransactionType.expense);

  const TransactionCategory(this.type);

  final TransactionType type;

  static List<TransactionCategory> forType(TransactionType type) =>
      values.where((c) => c.type == type).toList();

  static TransactionCategory defaultFor(TransactionType type) =>
      type == TransactionType.income ? salary : food;
}
