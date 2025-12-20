import 'package:flutter/material.dart';
import '../main.dart'; // Import main.dart untuk akses fungsi changeTheme

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Inisialisasi status mode gelap berdasarkan tema aplikasi saat ini
  bool _isDarkMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Mengecek apakah tema saat ini adalah gelap atau terang
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout Akun"),
        content: const Text("Apakah Anda yakin ingin keluar dari aplikasi Lahan Ternak?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              // Logika logout: Untuk saat ini hanya menampilkan pesan
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Berhasil keluar dari akun."),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              // Anda bisa menambahkan navigasi ke LoginScreen di sini jika sudah ada
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Peternak"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // Bagian Header Profil
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.account_circle_rounded, 
                    size: 110, 
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Admin Peternakan",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "admin@lahanternak.com",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Judul Seksi Pengaturan
          const Text(
            "PENGATURAN APLIKASI",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Card Pengaturan
          Card(
            child: Column(
              children: [
                // Switch Mode Gelap
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_rounded),
                  title: const Text("Mode Gelap"),
                  subtitle: const Text("Gunakan tema gelap untuk kenyamanan mata"),
                  value: _isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    // Memanggil fungsi changeTheme di main.dart
                    LahanTernakApp.of(context)?.changeTheme(
                      value ? ThemeMode.dark : ThemeMode.light
                    );
                  },
                ),
                const Divider(height: 1, indent: 60),
                // Bantuan
                ListTile(
                  leading: const Icon(Icons.help_outline_rounded),
                  title: const Text("Bantuan & Dukungan"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Fitur bantuan
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Judul Seksi Akun
          const Text(
            "AKUN",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Card Logout
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text(
                "Keluar dari Aplikasi", 
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
              ),
              onTap: _handleLogout,
            ),
          ),
          
          const SizedBox(height: 40),
          const Center(
            child: Text(
              "Versi Aplikasi 1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}