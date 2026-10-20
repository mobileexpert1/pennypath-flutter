import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_extensions.dart';
import '../../features/transactions/presentation/widgets/sync_status_banner.dart';

/// Bottom navigation on phones, navigation rail on tablets, desktop and web.
class HomeShell extends StatelessWidget {
  const HomeShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  void _select(int index) => shell.goBranch(index, initialLocation: index == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final destinations = [
      (Icons.space_dashboard_outlined, Icons.space_dashboard_rounded, l10n.navOverview),
      (Icons.receipt_long_outlined, Icons.receipt_long_rounded, l10n.navTransactions),
      (Icons.settings_outlined, Icons.settings_rounded, l10n.navSettings),
    ];
    final body = Column(
      children: [
        const SyncStatusBanner(),
        Expanded(child: shell),
      ],
    );

    if (context.isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _select,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final (icon, selected, label) in destinations)
                  NavigationRailDestination(
                    icon: Icon(icon),
                    selectedIcon: Icon(selected),
                    label: Text(label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _select,
        destinations: [
          for (final (icon, selected, label) in destinations)
            NavigationDestination(icon: Icon(icon), selectedIcon: Icon(selected), label: label),
        ],
      ),
    );
  }
}
