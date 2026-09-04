// lib/screens/menu_one_screen.dart
import 'package:flutter/material.dart';

class MenuOneScreen extends StatefulWidget {
  const MenuOneScreen({super.key});

  @override
  State<MenuOneScreen> createState() => _MenuOneScreenState();
}

class _MenuOneScreenState extends State<MenuOneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu 1')),
      body: const Center(child: Text('Menu 1 Screen')),
    );
  }
}