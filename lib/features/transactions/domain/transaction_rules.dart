enum TransactionFieldError {
  amountRequired,
  amountNotPositive,
  amountTooLarge,
  titleRequired,
  titleTooLong,
  noteTooLong,
  dateInFuture,
  categoryMismatch,
}

abstract final class TransactionRules {
  static const maxAmountMinor = 100000000000; // 1 billion in major units
  static const maxTitleLength = 60;
  static const maxNoteLength = 280;

  static TransactionFieldError? amount(int? minor) {
    if (minor == null) return TransactionFieldError.amountRequired;
    if (minor <= 0) return TransactionFieldError.amountNotPositive;
    if (minor > maxAmountMinor) return TransactionFieldError.amountTooLarge;
    return null;
  }

  static TransactionFieldError? title(String value) {
    final title = value.trim();
    if (title.isEmpty) return TransactionFieldError.titleRequired;
    if (title.length > maxTitleLength) return TransactionFieldError.titleTooLong;
    return null;
  }

  static TransactionFieldError? note(String? value) =>
      (value?.trim().length ?? 0) > maxNoteLength ? TransactionFieldError.noteTooLong : null;

  static TransactionFieldError? date(DateTime date, DateTime now) {
    final endOfToday = DateTime(now.year, now.month, now.day + 1);
    return date.isBefore(endOfToday) ? null : TransactionFieldError.dateInFuture;
  }
}
