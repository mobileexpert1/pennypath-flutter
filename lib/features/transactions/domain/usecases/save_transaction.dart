import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/analytics_service.dart';
import '../entities/transaction.dart';
import '../entities/transaction_draft.dart';
import '../repositories/transaction_repository.dart';
import '../transaction_rules.dart';

/// Validates and normalises a draft before it reaches the repository.
class SaveTransaction {
  const SaveTransaction({
    required this._repository,
    required this._analytics,
    required this._clock,
    required this._generateId,
  });

  final TransactionRepository _repository;
  final AnalyticsService _analytics;
  final DateTime Function() _clock;
  final String Function() _generateId;

  Future<Result<Transaction>> call(TransactionDraft draft) async {
    final now = _clock();
    final errors = <String, TransactionFieldError>{
      'amount': ?TransactionRules.amount(draft.amountMinor),
      'title': ?TransactionRules.title(draft.title),
      'note': ?TransactionRules.note(draft.note),
      'date': ?TransactionRules.date(draft.date, now),
      if (draft.category.type != draft.type) 'category': TransactionFieldError.categoryMismatch,
    };
    if (errors.isNotEmpty) return Err(ValidationFailure(errors));

    final note = draft.note?.trim();
    final transaction = Transaction(
      id: draft.id ?? _generateId(),
      type: draft.type,
      amountMinor: draft.amountMinor!,
      title: draft.title.trim(),
      category: draft.category,
      date: draft.date,
      note: note == null || note.isEmpty ? null : note,
      updatedAt: now.toUtc(),
    );

    final result = await _repository.save(transaction);
    if (result.isSuccess) {
      await _analytics.logEvent(AnalyticsEvent.transactionSaved, {
        'type': draft.type.name,
        'is_new': draft.id == null,
      });
    }
    return result;
  }
}
