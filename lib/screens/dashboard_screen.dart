import 'package:flutter/material.dart';
import 'ternak_list_screen.dart';
import 'kesehatan_list_screen.dart';
import 'pakan_list_screen.dart';
import 'reproduksi_list_screen.dart';
import 'profile_screen.dart'; // IMPORT WAJIB

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Daftar layar yang akan ditampilkan sesuai urutan tab
  final List<Widget> _screens = [
    const TernakListScreen(),
    const KesehatanListScreen(),
    const PakanListScreen(),
    const ProfileScreen(), // DAFTARKAN DI SINI (Index 3)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lahan Ternak'),
        // Logo kecil di AppBar jika diinginkan
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo_app.png', errorBuilder: (c, e, s) => const Icon(Icons.pets)),
        ),
      ),
      body: _screens[_selectedIndex], // Menampilkan layar berdasarkan index
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // Agar label selalu muncul
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Populasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety_outlined),
            activeIcon: Icon(Icons.health_and_safety),
            label: 'Kesehatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flatware_outlined),
            activeIcon: Icon(Icons.flatware),
            label: 'Pakan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil', // TAB PROFIL
          ),
        ],
      ),
    );
  }
}