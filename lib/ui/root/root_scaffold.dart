import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class RootScaffold extends StatelessWidget {
  const RootScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: [
          _buildDestination('expenses.svg', 'Расходы', 0),
          _buildDestination('income.svg', 'Доходы', 1),
          _buildDestination('account.svg', 'Счёт', 2),
          _buildDestination('category.svg', 'Статьи', 3),
          _buildDestination('settings.svg', 'Настройки', 4),
        ],
      ),
    );
  }

  NavigationDestination _buildDestination(
    String asset,
    String label,
    int index,
  ) {
    final isSelected = navigationShell.currentIndex == index;
    return NavigationDestination(
      icon: SvgPicture.asset(
        'assets/icons/$asset',
        width: 24,
        height: 24,
        colorFilter: isSelected
            ? null
            : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
      ),
      label: label,
    );
  }
}
