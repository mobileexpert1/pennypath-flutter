import '../../features/auth/domain/auth_rules.dart';
import '../../features/transactions/domain/transaction_rules.dart';
import '../error/failure.dart';
import 'generated/app_localizations.dart';

/// Single place that turns domain error codes into user-facing text.
extension FailureL10n on Failure {
  String message(AppLocalizations l10n) => switch (this) {
    NetworkFailure() => l10n.errorNetwork,
    UnauthorizedFailure() => l10n.errorUnauthorized,
    InvalidCredentialsFailure() => l10n.errorInvalidCredentials,
    EmailInUseFailure() => l10n.errorEmailInUse,
    NotFoundFailure() => l10n.errorNotFound,
    ServerFailure() => l10n.errorServer,
    StorageFailure() => l10n.errorStorage,
    ValidationFailure() => l10n.errorValidation,
    UnexpectedFailure() => l10n.errorUnexpected,
  };
}

extension AuthFieldErrorL10n on AuthFieldError {
  String message(AppLocalizations l10n) => switch (this) {
    AuthFieldError.nameRequired => l10n.nameRequired,
    AuthFieldError.emailRequired => l10n.emailRequired,
    AuthFieldError.emailInvalid => l10n.emailInvalid,
    AuthFieldError.passwordRequired => l10n.passwordRequired,
    AuthFieldError.passwordTooShort => l10n.passwordTooShort(AuthRules.minPasswordLength),
    AuthFieldError.passwordTooWeak => l10n.passwordTooWeak,
  };
}

extension TransactionFieldErrorL10n on TransactionFieldError {
  String message(AppLocalizations l10n) => switch (this) {
    TransactionFieldError.amountRequired => l10n.amountRequired,
    TransactionFieldError.amountNotPositive => l10n.amountNotPositive,
    TransactionFieldError.amountTooLarge => l10n.amountTooLarge,
    TransactionFieldError.titleRequired => l10n.titleRequired,
    TransactionFieldError.titleTooLong => l10n.titleTooLong(TransactionRules.maxTitleLength),
    TransactionFieldError.noteTooLong => l10n.noteTooLong(TransactionRules.maxNoteLength),
    TransactionFieldError.dateInFuture => l10n.dateInFuture,
    TransactionFieldError.categoryMismatch => l10n.categoryMismatch,
  };
}
