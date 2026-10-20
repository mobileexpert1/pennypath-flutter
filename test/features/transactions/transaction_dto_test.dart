import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/features/transactions/data/models/transaction_dto.dart';
import 'package:pennypath/features/transactions/domain/entities/transaction_category.dart';

import '../../helpers/builders.dart';

void main() {
  test('round-trips an entity through JSON', () {
    final original = buildTransaction(note: 'Team lunch');
    final json = TransactionDto.fromEntity(original).toJson();
    expect(TransactionDto.fromJson(json).toEntity(), original);
  });

  test('omits a null note', () {
    expect(TransactionDto.fromEntity(buildTransaction()).toJson(), isNot(contains('note')));
  });

  test('unknown categories from a newer API fall back safely', () {
    final json = TransactionDto.fromEntity(buildTransaction()).toJson()..['category'] = 'crypto';
    expect(TransactionDto.fromJson(json).toEntity().category, TransactionCategory.otherExpense);
  });
}
