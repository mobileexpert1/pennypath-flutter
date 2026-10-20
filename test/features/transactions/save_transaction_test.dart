import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypath/core/error/failure.dart';
import 'package:pennypath/core/error/result.dart';
import 'package:pennypath/features/transactions/domain/entities/transaction.dart';
import 'package:pennypath/features/transactions/domain/entities/transaction_category.dart';
import 'package:pennypath/features/transactions/domain/entities/transaction_draft.dart';
import 'package:pennypath/features/transactions/domain/entities/transaction_type.dart';
import 'package:pennypath/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:pennypath/features/transactions/domain/transaction_rules.dart';
import 'package:pennypath/features/transactions/domain/usecases/save_transaction.dart';

import '../../helpers/builders.dart';
import '../../helpers/fakes.dart';

class _MockRepository extends Mock implements TransactionRepository {}

void main() {
  final now = DateTime(2026, 10, 20, 9);
  late _MockRepository repository;
  late FakeAnalytics analytics;
  late SaveTransaction save;

  setUpAll(() => registerFallbackValue(buildTransaction()));

  setUp(() {
    repository = _MockRepository();
    analytics = FakeAnalytics();
    save = SaveTransaction(
      repository: repository,
      analytics: analytics,
      clock: () => now,
      generateId: () => 'new-id',
    );
    when(
      () => repository.save(any()),
    ).thenAnswer((call) async => Success(call.positionalArguments.first as Transaction));
  });

  TransactionDraft draft({
    String? id,
    int? amount = 1999,
    String title = '  Coffee  ',
    TransactionType type = TransactionType.expense,
    TransactionCategory category = TransactionCategory.food,
    DateTime? date,
    String? note = '   ',
  }) => TransactionDraft(
    id: id,
    type: type,
    amountMinor: amount,
    title: title,
    category: category,
    date: date ?? now,
    note: note,
  );

  test('normalises input, assigns an id and timestamp, then saves', () async {
    final result = await save(draft());

    final saved = result.valueOrNull!;
    expect(saved.id, 'new-id');
    expect(saved.title, 'Coffee');
    expect(saved.note, isNull);
    expect(saved.updatedAt, now.toUtc());
    expect(analytics.events, ['transaction_saved']);
  });

  test('keeps the id when editing', () async {
    final result = await save(draft(id: 'existing'));
    expect(result.valueOrNull!.id, 'existing');
  });

  test('returns every field error and never touches the repository', () async {
    final result = await save(
      draft(
        amount: 0,
        title: ' ',
        date: now.add(const Duration(days: 2)),
        category: TransactionCategory.salary,
      ),
    );

    final failure = result.failureOrNull! as ValidationFailure<TransactionFieldError>;
    expect(failure.errors, {
      'amount': TransactionFieldError.amountNotPositive,
      'title': TransactionFieldError.titleRequired,
      'date': TransactionFieldError.dateInFuture,
      'category': TransactionFieldError.categoryMismatch,
    });
    verifyNever(() => repository.save(any()));
    expect(analytics.events, isEmpty);
  });

  test('allows any time later today', () async {
    final result = await save(draft(date: DateTime(2026, 10, 20, 23, 59)));
    expect(result.isSuccess, isTrue);
  });
}
