import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// Accepts only certificates whose SHA-256 DER fingerprint is in [pins].
HttpClientAdapter? createPinnedAdapter(Set<String> pins) {
  if (pins.isEmpty) return null;
  return IOHttpClientAdapter(
    createHttpClient: () => HttpClient()..badCertificateCallback = (_, _, _) => false,
    validateCertificate: (cert, host, port) {
      if (cert == null) return false;
      return pins.contains(base64Encode(sha256.convert(cert.der).bytes));
    },
  );
}
