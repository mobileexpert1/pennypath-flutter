import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/app_lock/presentation/controllers/app_lock_controller.dart';
import '../../features/app_lock/presentation/screens/lock_screen.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/transactions/presentation/screens/transaction_form_screen.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import '../widgets/home_shell.dart';
import '../widgets/splash_screen.dart';
import 'routes.dart';

final _rootKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref
    ..listen(authControllerProvider, (_, _) => refresh.value++)
    ..listen(appLockControllerProvider, (_, _) => refresh.value++)
    ..onDispose(refresh.dispose);

  final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.dashboard,
    refreshListenable: refresh,
    redirect: (context, state) => resolveRedirect(
      location: state.matchedLocation,
      auth: ref.read(authControllerProvider),
      locked: ref.read(appLockControllerProvider),
    ),
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.auth, builder: (_, _) => const AuthScreen()),
      GoRoute(path: Routes.lock, builder: (_, _) => const LockScreen()),
      GoRoute(
        path: Routes.newTransaction,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const TransactionFormScreen(),
      ),
      GoRoute(
        path: '/transactions/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => TransactionFormScreen(transactionId: state.pathParameters['id']),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.dashboard, builder: (_, _) => const DashboardScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.transactions, builder: (_, _) => const TransactionsScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.settings, builder: (_, _) => const SettingsScreen())],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

/// Pure function so the navigation rules are unit-testable.
String? resolveRedirect({
  required String location,
  required AsyncValue<Object?> auth,
  required bool locked,
}) {
  if (!auth.hasValue && !auth.hasError) return location == Routes.splash ? null : Routes.splash;

  final signedIn = auth.value != null;
  if (!signedIn) return location == Routes.auth ? null : Routes.auth;
  if (locked) return location == Routes.lock ? null : Routes.lock;

  const gates = {Routes.splash, Routes.auth, Routes.lock};
  return gates.contains(location) ? Routes.dashboard : null;
}
