import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return const SizedBox.shrink();
    final initials = user.name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return Padding(
      padding: AppSpacing.screen,
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(AppSpacing.md),
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: context.colors.primaryContainer,
            child: Text(initials, style: context.text.titleMedium),
          ),
          title: Text(user.name, style: context.text.titleMedium),
          subtitle: Text(user.email),
        ),
      ),
    );
  }
}
