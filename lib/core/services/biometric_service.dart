import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

abstract interface class BiometricService {
  Future<bool> isAvailable();
  Future<bool> authenticate(String reason);
}

class LocalAuthBiometricService implements BiometricService {
  LocalAuthBiometricService([LocalAuthentication? auth]) : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    if (kIsWeb) return false;
    try {
      return await _auth.isDeviceSupported();
    } on Exception {
      return false;
    }
  }

  /// Falls back to the device PIN/passcode when biometrics are unavailable.
  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason);
    } on Exception {
      return false;
    }
  }
}
