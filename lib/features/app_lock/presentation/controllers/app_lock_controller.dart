import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/core_providers.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../settings/presentation/controllers/settings_controller.dart';

final appLockControllerProvider = NotifierProvider<AppLockController, bool>(AppLockController.new);

/// `true` while the app is locked. Locks on launch and after the app has been
/// in the background longer than [gracePeriod].
class AppLockController extends Notifier<bool> {
  static const gracePeriod = Duration(seconds: 30);

  DateTime? _hiddenAt;
  bool _authenticating = false;

  bool get _enabled => ref.read(settingsControllerProvider).appLockEnabled;

  @override
  bool build() {
    ref.listen(settingsControllerProvider.select((s) => s.appLockEnabled), (_, enabled) {
      if (!enabled) state = false;
    });
    ref.listen(authControllerProvider.select((auth) => auth.value?.id), (_, userId) {
      if (userId == null) state = false;
    });
    return _enabled;
  }

  void onAppHidden() => _hiddenAt ??= ref.read(clockProvider)();

  void onAppShown() {
    final hiddenAt = _hiddenAt;
    _hiddenAt = null;
    if (!_enabled || hiddenAt == null) return;
    if (ref.read(clockProvider)().difference(hiddenAt) >= gracePeriod) state = true;
  }

  Future<void> unlock(String reason) async {
    if (_authenticating || !state) return;
    _authenticating = true;
    try {
      if (await ref.read(biometricServiceProvider).authenticate(reason)) state = false;
    } finally {
      _authenticating = false;
    }
  }
}
