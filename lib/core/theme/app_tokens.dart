import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;

  static const screen = EdgeInsets.all(md);
  static const maxContentWidth = 720.0;
}

abstract final class AppRadius {
  static const sm = 8.0;
  static const md = 14.0;
  static const lg = 24.0;
}

/// Square spacer that works in rows and columns.
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size);
}
