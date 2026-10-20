import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/features/auth/presentation/screens/auth_screen.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('validates fields before calling the backend', (tester) async {
    final env = TestEnvironment();
    await tester.pumpScreen(const AuthScreen(), overrides: env.overrides);

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pump();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
  });

  testWidgets('sign-up mode adds the name field and the password policy', (tester) async {
    final env = TestEnvironment();
    await tester.pumpScreen(const AuthScreen(), overrides: env.overrides);

    await tester.tap(find.text('New here? Create an account'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'sam@mail.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();

    expect(find.text('Enter your name'), findsOneWidget);
    expect(find.text('Use both letters and numbers'), findsOneWidget);
  });

  testWidgets('shows a friendly error for wrong credentials', (tester) async {
    final env = TestEnvironment();
    await tester.pumpScreen(const AuthScreen(), overrides: env.overrides);

    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'demo@pennypath.app');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'nope');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Incorrect email or password.'), findsOneWidget);
  });

  testWidgets('password visibility can be toggled', (tester) async {
    await tester.pumpScreen(const AuthScreen(), overrides: TestEnvironment().overrides);

    EditableText password() => tester.widget<EditableText>(
      find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(EditableText),
      ),
    );
    expect(password().obscureText, isTrue);
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(password().obscureText, isFalse);
  });
}
