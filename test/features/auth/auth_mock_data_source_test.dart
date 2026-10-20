import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/core/error/exceptions.dart';
import 'package:pennypath/core/mock/demo_account.dart';
import 'package:pennypath/core/mock/mock_network.dart';
import 'package:pennypath/features/auth/data/datasources/auth_mock_data_source.dart';

import '../../helpers/fakes.dart';

void main() {
  late InMemoryLocalDatabase database;
  late bool offline;
  late AuthMockDataSource source;

  setUp(() {
    database = InMemoryLocalDatabase();
    offline = false;
    source = AuthMockDataSource(
      database: database,
      network: MockNetwork(isOffline: () => offline, latency: Duration.zero),
    );
  });

  test('the demo account exists out of the box', () async {
    final session = await source.signIn(email: DemoAccount.email, password: DemoAccount.password);
    expect(session.user.name, DemoAccount.name);
    expect(session.accessToken, isNot(session.refreshToken));
  });

  test('sign up then sign in; emails are case-insensitive', () async {
    await source.signUp(name: 'Sam', email: 'Sam@Mail.com', password: 'abcd1234');
    final session = await source.signIn(email: 'sam@mail.com', password: 'abcd1234');
    expect(session.user.name, 'Sam');
  });

  test('stores salted hashes, never the password', () async {
    await source.signUp(name: 'Sam', email: 'sam@mail.com', password: 'abcd1234');
    final users = await (await database.collection('mock_server_users')).getAll();
    expect(users.toString(), isNot(contains('abcd1234')));
  });

  test('rejects wrong passwords and duplicate emails', () async {
    await expectLater(
      source.signIn(email: DemoAccount.email, password: 'wrong'),
      throwsA(isA<InvalidCredentialsException>()),
    );
    await expectLater(
      source.signUp(name: 'X', email: DemoAccount.email, password: 'abcd1234'),
      throwsA(isA<EmailInUseException>()),
    );
  });

  test('fails like a real network when offline is simulated', () async {
    offline = true;
    await expectLater(
      source.signIn(email: DemoAccount.email, password: DemoAccount.password),
      throwsA(isA<NetworkException>()),
    );
  });
}
