import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/haptic_feedback.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onItemTapped(int index) {
    HapticUtils.selectionClick();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: navigationShell,
        bottomNavigationBar: Semantics(
          label: 'Bottom navigation',
          child: NavigationBar(
            height: 70,
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onItemTapped,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.insights_outlined),
                selectedIcon: Icon(Icons.insights_rounded),
                label: 'Insights',
              ),
              NavigationDestination(
                icon: Icon(Icons.savings_outlined),
                selectedIcon: Icon(Icons.savings_rounded),
                label: 'Save',
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications_outlined),
                selectedIcon: Icon(Icons.notifications_active_rounded),
                label: 'Alerts',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline_rounded),
                selectedIcon: Icon(Icons.chat_bubble_rounded),
                label: 'Chat',
              ),
            ],
          ),
        ),
      );
}
