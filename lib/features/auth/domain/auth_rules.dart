enum AuthFieldError {
  nameRequired,
  emailRequired,
  emailInvalid,
  passwordRequired,
  passwordTooShort,
  passwordTooWeak,
}

/// Shared by the forms and any future server-side mirror of these rules.
abstract final class AuthRules {
  static const minPasswordLength = 8;
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]{2,}$');
  static final _letter = RegExp('[A-Za-z]');
  static final _digit = RegExp(r'\d');

  static AuthFieldError? name(String value) =>
      value.trim().isEmpty ? AuthFieldError.nameRequired : null;

  static AuthFieldError? email(String value) {
    final email = value.trim();
    if (email.isEmpty) return AuthFieldError.emailRequired;
    if (!_email.hasMatch(email)) return AuthFieldError.emailInvalid;
    return null;
  }

  /// Sign-in only checks presence so policy changes never lock users out.
  static AuthFieldError? password(String value, {required bool isSignUp}) {
    if (value.isEmpty) return AuthFieldError.passwordRequired;
    if (!isSignUp) return null;
    if (value.length < minPasswordLength) return AuthFieldError.passwordTooShort;
    if (!_letter.hasMatch(value) || !_digit.hasMatch(value)) {
      return AuthFieldError.passwordTooWeak;
    }
    return null;
  }
}
