import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/core/mock/demo_account.dart';

import '../helpers/test_app.dart';

Future<void> _signInAsDemo(WidgetTester tester) async {
  await tester.tap(find.text('Use demo account'));
  await tester.pump();
  await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
  await tester.pumpAndSettle();
}

void main() {
  late TestEnvironment env;

  setUp(() => env = TestEnvironment());

  testWidgets('demo sign-in lands on the overview with seeded data', (tester) async {
    await tester.pumpPennypath(env);
    expect(find.text('Take control of your money'), findsOneWidget);

    await _signInAsDemo(tester);

    expect(find.text('Hi, ${DemoAccount.name.split(' ').first}'), findsOneWidget);
    expect(find.text('Total balance'), findsOneWidget);
    expect(find.text('Spending by category'), findsOneWidget);
    expect(env.analytics.events, contains('sign_in'));
  });

  testWidgets('add a transaction, find it with search, then delete it with undo', (tester) async {
    await tester.pumpPennypath(env);
    await _signInAsDemo(tester);
    await tester.tap(find.text('Transactions').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add transaction'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '42,50');
    await tester.enterText(find.widgetWithText(TextFormField, 'Title'), 'Board games');
    await tester.tap(find.text('Entertainment'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Transaction saved'), findsOneWidget);
    await tester.enterText(find.byType(SearchBar), 'board');
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    expect(find.text('Board games'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(ListTile), matching: find.text(r'−$42.50')),
      findsOneWidget,
    );

    await tester.drag(find.text('Board games'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Board games'), findsNothing);
    expect(find.text('No matches'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Board games'), findsOneWidget);
  });

  testWidgets('works offline and tells the user changes will sync later', (tester) async {
    await tester.pumpPennypath(env);
    await _signInAsDemo(tester);

    env.offline = true;
    await tester.tap(find.byTooltip('Add transaction'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '3');
    await tester.enterText(find.widgetWithText(TextFormField, 'Title'), 'Offline coffee');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Offline coffee'), findsOneWidget);
    expect(find.text('Offline · 1 change will sync later'), findsOneWidget);

    env.offline = false;
    await tester.tap(find.byTooltip('Try again'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Offline ·'), findsNothing);
  });

  testWidgets('switching language to German updates the whole UI', (tester) async {
    await tester.pumpPennypath(env);
    await _signInAsDemo(tester);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deutsch'));
    await tester.pumpAndSettle();

    expect(find.text('Einstellungen'), findsWidgets);
    expect(find.text('Sprache'), findsOneWidget);
    expect(env.keyValueStore.values['settings.language'], 'de');
  });

  testWidgets('sign out wipes local data and returns to the auth screen', (tester) async {
    await tester.pumpPennypath(env);
    await _signInAsDemo(tester);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.widgetWithText(OutlinedButton, 'Sign out'), 200);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(find.text('Take control of your money'), findsOneWidget);
    expect(env.secureStore.values.containsKey('auth_session'), isFalse);
    final local = await (await env.database.collection('transactions')).getAll();
    expect(local, isEmpty);
  });
}
