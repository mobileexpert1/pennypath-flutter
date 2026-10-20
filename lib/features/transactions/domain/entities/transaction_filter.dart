import 'package:equatable/equatable.dart';

import 'transaction.dart';
import 'transaction_type.dart';

class TransactionFilter extends Equatable {
  const TransactionFilter({this.query = '', this.type});

  final String query;
  final TransactionType? type;

  bool get isActive => query.trim().isNotEmpty || type != null;

  TransactionFilter copyWith({String? query, TransactionType? Function()? type}) =>
      TransactionFilter(query: query ?? this.query, type: type != null ? type() : this.type);

  @override
  List<Object?> get props => [query, type];
}

class TransactionGroup extends Equatable {
  const TransactionGroup({required this.day, required this.transactions});

  final DateTime day;
  final List<Transaction> transactions;

  int get netMinor => transactions.fold(0, (sum, t) => sum + t.signedAmountMinor);

  @override
  List<Object?> get props => [day, transactions];
}
