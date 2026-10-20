import 'package:flutter/material.dart';

enum AppButtonVariant { filled, tonal, outlined, text }

/// One button for the whole app, with a built-in loading state.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = AppButtonVariant.filled,
    this.expand = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final AppButtonVariant variant;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final onTap = isLoading ? null : onPressed;
    final child = isLoading
        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
        : Text(label);
    final iconWidget = icon == null || isLoading ? null : Icon(icon);

    final button = switch (variant) {
      AppButtonVariant.filled => FilledButton.icon(
        onPressed: onTap,
        icon: iconWidget,
        label: child,
      ),
      AppButtonVariant.tonal => FilledButton.tonalIcon(
        onPressed: onTap,
        icon: iconWidget,
        label: child,
      ),
      AppButtonVariant.outlined => OutlinedButton.icon(
        onPressed: onTap,
        icon: iconWidget,
        label: child,
      ),
      AppButtonVariant.text => TextButton.icon(onPressed: onTap, icon: iconWidget, label: child),
    };

    return Semantics(
      button: true,
      label: isLoading ? label : null,
      child: expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}
