import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/core/config/app_config.dart';

AppConfig _rest(String url) => AppConfig(
  environment: 'test',
  backend: BackendMode.rest,
  apiBaseUrl: url,
  certificatePins: const {},
);

void main() {
  test('mock backend needs no URL', () {
    expect(
      const AppConfig(
        environment: 'demo',
        backend: BackendMode.mock,
        apiBaseUrl: '',
        certificatePins: {},
      ).validate,
      returnsNormally,
    );
  });

  test('rest backend requires an https URL', () {
    expect(_rest('').validate, throwsStateError);
    expect(_rest('http://api.example.com').validate, throwsStateError);
    expect(_rest('https://api.example.com/v1').validate, returnsNormally);
  });

  test('allows http only for local development hosts', () {
    expect(_rest('http://localhost:8080').validate, returnsNormally);
    expect(_rest('http://10.0.2.2:8080').validate, returnsNormally);
  });
}
