import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/features/auth/domain/auth_rules.dart';

void main() {
  test('email', () {
    expect(AuthRules.email(''), AuthFieldError.emailRequired);
    expect(AuthRules.email('alex@'), AuthFieldError.emailInvalid);
    expect(AuthRules.email('alex@mail'), AuthFieldError.emailInvalid);
    expect(AuthRules.email(' alex@mail.com '), isNull);
  });

  test('sign-up passwords must be long and mix letters with digits', () {
    expect(AuthRules.password('', isSignUp: true), AuthFieldError.passwordRequired);
    expect(AuthRules.password('abc1', isSignUp: true), AuthFieldError.passwordTooShort);
    expect(AuthRules.password('abcdefgh', isSignUp: true), AuthFieldError.passwordTooWeak);
    expect(AuthRules.password('12345678', isSignUp: true), AuthFieldError.passwordTooWeak);
    expect(AuthRules.password('abcd1234', isSignUp: true), isNull);
  });

  test('sign-in only checks presence so policy changes never lock users out', () {
    expect(AuthRules.password('', isSignUp: false), AuthFieldError.passwordRequired);
    expect(AuthRules.password('old', isSignUp: false), isNull);
  });
}
