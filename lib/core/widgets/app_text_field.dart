import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/context_extensions.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    this.controller,
    this.hint,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.prefixIcon,
    this.prefixText,
    this.isPassword = false,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.onSubmitted,
    this.style,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final String? prefixText;
  final bool isPassword;
  final int maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onSubmitted;
  final TextStyle? style;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      inputFormatters: widget.inputFormatters,
      obscureText: _obscured,
      enableSuggestions: !widget.isPassword,
      autocorrect: !widget.isPassword,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      onFieldSubmitted: widget.onSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: widget.style,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixText: widget.prefixText,
        prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
        counterText: '',
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: _obscured ? l10n.showPassword : l10n.hidePassword,
                icon: Icon(_obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscured = !_obscured),
              )
            : null,
      ),
    );
  }
}
