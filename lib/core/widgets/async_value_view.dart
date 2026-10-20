import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'status_view.dart';

/// Renders loading and error states the same way everywhere.
/// Keeps showing previous data while refreshing.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({required this.value, required this.data, this.onRetry, super.key});

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (value.hasValue) return data(value.requireValue);
    if (value.hasError) {
      return StatusView.failure(context, value.error!, onRetry: onRetry);
    }
    return const Center(child: CircularProgressIndicator());
  }
}
