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

  BottomNavigationBarItem _buildItem(String asset, String label, int index) {
    final isSelected = navigationShell.currentIndex == index;
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        'assets/icons/$asset',
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          isSelected ? const Color(0xFF2ECC71) : Colors.grey,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2ECC71),
        unselectedItemColor: Colors.grey,
        currentIndex: navigationShell.currentIndex,
        onTap: _goBranch,
        items: [
          _buildItem('expenses.svg', 'Расходы', 0),
          _buildItem('income.svg', 'Доходы', 1),
          _buildItem('account.svg', 'Счёт', 2),
          _buildItem('category.svg', 'Статьи', 3),
          _buildItem('settings.svg', 'Настройки', 4),
        ],
      ),
    );
  }
}
