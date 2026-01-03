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

  final List<Widget> _screens = [
    const TernakListScreen(),
    const KesehatanListScreen(),
    const PakanListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar Lurus (Tanpa 'shape')
      appBar: AppBar(
        title: const Text('Lahan Ternak'),
        elevation: 0, 
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        // Hapus properti 'shape' jika ada disini
      ),
      body: _screens[_selectedIndex],
      
      // Bottom Navbar Modern dengan Icon
      bottomNavigationBar: Container(
        // Memberikan shadow halus di atas navbar agar terlihat modern (floating effect)
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
          elevation: 0, // Elevation dimatikan karena sudah pakai shadow container
          
          // Warna Modern
          selectedItemColor: const Color(0xFF2E7D32),
          unselectedItemColor: Colors.grey.shade400,
          
          // Style Font
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined), // Icon Garis (Unselected)
              activeIcon: Icon(Icons.inventory_2),    // Icon Isi (Selected)
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