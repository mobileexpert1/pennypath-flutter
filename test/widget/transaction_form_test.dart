import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/features/transactions/presentation/screens/transaction_form_screen.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('shows localized validation errors from the shared rules', (tester) async {
    await tester.pumpScreen(const TransactionFormScreen(), overrides: TestEnvironment().overrides);

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Enter an amount'), findsOneWidget);
    expect(find.text('Enter a title'), findsOneWidget);
  });

  testWidgets('switching type swaps the category options', (tester) async {
    await tester.pumpScreen(const TransactionFormScreen(), overrides: TestEnvironment().overrides);
    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Salary'), findsNothing);

    await tester.tap(find.text('Income'));
    await tester.pumpAndSettle();

    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Groceries'), findsNothing);
  });

  testWidgets('the amount field only accepts money input', (tester) async {
    await tester.pumpScreen(const TransactionFormScreen(), overrides: TestEnvironment().overrides);
    final amount = find.widgetWithText(TextFormField, 'Amount');

    await tester.enterText(amount, '12.345abc');
    expect(tester.widget<TextFormField>(amount).controller!.text, isEmpty);

    await tester.enterText(amount, '12.34');
    expect(tester.widget<TextFormField>(amount).controller!.text, '12.34');
  });
}
