import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/app/di/core_providers.dart';
import 'package:pennypath/features/app_lock/presentation/controllers/app_lock_controller.dart';
import 'package:pennypath/features/settings/presentation/controllers/settings_controller.dart';

import '../../helpers/test_app.dart';

void main() {
  late TestEnvironment env;
  late ProviderContainer container;

  setUp(() {
    env = TestEnvironment();
    env.keyValueStore.values['settings.appLock'] = true;
    container = ProviderContainer.test(overrides: env.overrides);
  });

  AppLockController lock() => container.read(appLockControllerProvider.notifier);
  bool isLocked() => container.read(appLockControllerProvider);

  test('starts locked when enabled and unlocks after authentication', () async {
    expect(isLocked(), isTrue);
    await lock().unlock('reason');
    expect(isLocked(), isFalse);
  });

  test('stays locked when authentication fails', () async {
    env.biometrics.succeeds = false;
    await lock().unlock('reason');
    expect(isLocked(), isTrue);
  });

  test('re-locks only after the grace period in the background', () async {
    await lock().unlock('reason');

    lock().onAppHidden();
    env.now = env.now.add(const Duration(seconds: 5));
    lock().onAppShown();
    expect(isLocked(), isFalse);

    lock().onAppHidden();
    env.now = env.now.add(AppLockController.gracePeriod);
    lock().onAppShown();
    expect(isLocked(), isTrue);
  });

  test('turning the lock off unlocks immediately', () async {
    expect(isLocked(), isTrue);
    await container
        .read(settingsControllerProvider.notifier)
        .setAppLock(enabled: false, reason: 'reason');
    expect(isLocked(), isFalse);
    expect(container.read(clockProvider)(), env.now);
  });
}
