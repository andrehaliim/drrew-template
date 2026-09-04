// lib/screens/menu_two_screen.dart
import 'package:flutter/material.dart';

class MenuTwoScreen extends StatefulWidget {
  const MenuTwoScreen({super.key});

  @override
  State<MenuTwoScreen> createState() => _MenuTwoScreenState();
}

class _MenuTwoScreenState extends State<MenuTwoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu 2')),
      body: const Center(child: Text('Menu 2 Screen')),
    );
  }
}