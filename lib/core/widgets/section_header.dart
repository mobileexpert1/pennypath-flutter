import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_tokens.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.trailing, this.padding, super.key});

  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ??
          const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: context.text.titleSmall?.copyWith(color: context.colors.primary),
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
