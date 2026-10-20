import '../error/exceptions.dart';

/// Simulates latency and connectivity for the in-app mock backend.
class MockNetwork {
  MockNetwork({required this._isOffline, this.latency = const Duration(milliseconds: 450)});

  final bool Function() _isOffline;
  final Duration latency;

  Future<void> roundTrip() async {
    await Future<void>.delayed(latency);
    if (_isOffline()) throw const NetworkException('Simulated offline');
  }
}
