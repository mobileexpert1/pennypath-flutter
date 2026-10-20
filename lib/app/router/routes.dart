abstract final class Routes {
  static const splash = '/splash';
  static const auth = '/auth';
  static const lock = '/lock';
  static const dashboard = '/';
  static const transactions = '/transactions';
  static const settings = '/settings';
  static const newTransaction = '/transactions/new';

  static String editTransaction(String id) => '/transactions/$id';
}
