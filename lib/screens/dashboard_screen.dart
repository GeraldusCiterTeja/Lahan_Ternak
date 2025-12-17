import 'package:flutter/material.dart';
import 'ternak_list_screen.dart';
import 'kesehatan_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const TernakListScreen(),
    const KesehatanListScreen(),
    const Center(child: Text("Modul Pakan - Segera Hadir")),
    const Center(child: Text("Modul Reproduksi - Segera Hadir")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo_app.png',
              height: 32,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets),
            ),
            const SizedBox(width: 12),
            const Text("Lahan Ternak", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined), 
            selectedIcon: Icon(Icons.inventory_2), 
            label: 'Populasi'
          ),
          NavigationDestination(
            icon: Icon(Icons.health_and_safety_outlined), 
            selectedIcon: Icon(Icons.health_and_safety), 
            label: 'Kesehatan'
          ),
          NavigationDestination(
            icon: Icon(Icons.set_meal_outlined), 
            selectedIcon: Icon(Icons.set_meal), 
            label: 'Pakan'
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border), 
            selectedIcon: Icon(Icons.favorite), 
            label: 'Reproduksi'
          ),
        ],
      ),
    );
  }
}