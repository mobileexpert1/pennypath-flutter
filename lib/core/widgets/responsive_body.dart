import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Centers content with a readable max width on tablets, desktop and web.
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({
    required this.child,
    this.maxWidth = AppSpacing.maxContentWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
