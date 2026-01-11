import 'package:flutter/material.dart';
import 'ternak_list_screen.dart';
import 'kesehatan_list_screen.dart';
import 'pakan_list_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // 1. Daftar Halaman untuk Body
  final List<Widget> _screens = [
    const TernakListScreen(),     // Index 0
    const KesehatanListScreen(),  // Index 1
    const PakanListScreen(),      // Index 2
    const ProfileScreen(),        // Index 3
  ];

  // 2. Daftar Judul AppBar (Sesuai urutan menu)
  final List<String> _titles = [
    'Data Populasi Ternak',
    'Riwayat Kesehatan',
    'Manajemen Pakan',
    'Profil Pengguna',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- PERBAIKAN: APPBAR DIKEMBALIKAN ---
      appBar: AppBar(
        // Judul berubah otomatis sesuai tab yang dipilih
        title: Text(
          _titles[_selectedIndex], 
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        backgroundColor: const Color(0xFF2E7D32), // Hijau Tema
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // Judul di tengah agar rapi
      ),
      
      body: _screens[_selectedIndex],
      
      // Bottom Navbar Modern
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          
          selectedItemColor: const Color(0xFF2E7D32),
          unselectedItemColor: Colors.grey.shade400,
          
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          
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
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}