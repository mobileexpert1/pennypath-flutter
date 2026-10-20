import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Icon(Icons.savings_rounded, size: 72, color: Theme.of(context).colorScheme.primary),
    ),
  );
}
