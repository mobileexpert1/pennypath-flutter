import 'package:dio/dio.dart';

/// Browsers manage TLS themselves, so pinning is not available on web.
HttpClientAdapter? createPinnedAdapter(Set<String> pins) => null;
