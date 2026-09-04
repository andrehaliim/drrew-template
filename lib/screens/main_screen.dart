// lib/screens/main_screen.dart
import 'package:drrew_template/widgets/app_navbar.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'menu_one_screen.dart';
import 'menu_two_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _initialIndex = 0; // Home paling kiri = initial tab

  int _currentIndex = _initialIndex;

  final _pages = const [
    HomeScreen(),
    MenuOneScreen(),
    MenuTwoScreen(),
    SettingsScreen(),
  ];

  static const _items = [
    AppNavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
    AppNavItem(icon: Icons.widgets_outlined, selectedIcon: Icons.widgets, label: 'Menu 1'),
    AppNavItem(icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard, label: 'Menu 2'),
    AppNavItem(icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: 'Settings'),
  ];

  void _onDestinationSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNav(
        items: _items,
        currentIndex: _currentIndex,
        onTap: _onDestinationSelected,
      ),
    );
  }
}