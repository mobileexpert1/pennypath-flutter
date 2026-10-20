import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pennypath/core/storage/hive_local_database.dart';
import 'package:pennypath/core/storage/secure_store.dart';

import '../test/helpers/test_app.dart';

/// Runs on a real device or simulator: `flutter test integration_test`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('native secure storage and the encrypted database work on device', (tester) async {
    const store = FlutterSecureStore();
    await store.write('it_probe', 'secret');
    expect(await store.read('it_probe'), 'secret');
    await store.delete('it_probe');
    expect(await store.read('it_probe'), isNull);

    final database = await HiveLocalDatabase.open(store);
    final probe = await database.collection('it_probe');
    await probe.put('a', {'amountMinor': 1250});
    expect(await probe.get('a'), {'amountMinor': 1250});
    await probe.clear();
  });

  testWidgets('sign in, add an expense and see it on the overview', (tester) async {
    await tester.pumpPennypath(TestEnvironment());

    await tester.tap(find.text('Use demo account'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Total balance'), findsOneWidget);

    await tester.tap(find.byTooltip('Add transaction'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '12.40');
    await tester.enterText(find.widgetWithText(TextFormField, 'Title'), 'Integration lunch');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Integration lunch'), findsOneWidget);
  });
}
