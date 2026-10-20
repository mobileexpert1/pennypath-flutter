import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/presentation/controllers/settings_controller.dart';
import '../controllers/app_lock_controller.dart';

/// Tracks the app lifecycle for auto-locking and blurs content in the app
/// switcher so balances are never captured in OS snapshots.
class AppLockGuard extends ConsumerStatefulWidget {
  const AppLockGuard({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppLockGuard> createState() => _AppLockGuardState();
}

class _AppLockGuardState extends ConsumerState<AppLockGuard> {
  late final AppLifecycleListener _listener;
  bool _obscured = false;

  @override
  void initState() {
    super.initState();
    final lock = ref.read(appLockControllerProvider.notifier);
    _listener = AppLifecycleListener(
      onInactive: () => setState(() => _obscured = true),
      onResume: () => setState(() => _obscured = false),
      onHide: lock.onAppHidden,
      onShow: lock.onAppShown,
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(settingsControllerProvider.select((s) => s.appLockEnabled));
    return Stack(
      children: [
        widget.child,
        if (enabled && _obscured)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: ColoredBox(
                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
              ),
            ),
          ),
      ],
    );
  }
}
