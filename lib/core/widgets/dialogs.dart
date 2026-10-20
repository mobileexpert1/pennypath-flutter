import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: context.colors.error,
                  foregroundColor: context.colors.onError,
                )
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Generic single-choice bottom sheet used for theme, language and currency.
Future<T?> showChoiceSheet<T>(
  BuildContext context, {
  required String title,
  required List<T> options,
  required T selected,
  required String Function(T option) labelOf,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    builder: (context) => SafeArea(
      child: RadioGroup<T>(
        groupValue: selected,
        onChanged: (value) => Navigator.pop(context, value),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(title: Text(title, style: context.text.titleMedium)),
            for (final option in options)
              RadioListTile<T>(value: option, title: Text(labelOf(option))),
          ],
        ),
      ),
    ),
  );
}
