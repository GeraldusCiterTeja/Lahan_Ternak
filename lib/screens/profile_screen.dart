import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- DATA DUMMY PETERNAK ---
    const String nama = "Al Abdi Malik Rahman";
    const String role = "Pemilik Peternakan"; 
    const String idPeternak = "PTR-2025-088";
    const String namaKandang = "Lahan Ternak Berkah";
    const String lokasi = "Cikarang, Jawa Barat";
    // Spesialisasi DIHAPUS sesuai permintaan
    const String noHp = "+62 812-3456-7890";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER PROFIL (Hijau) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32), // Hijau Konsisten
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Avatar Foto
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 60, color: Color(0xFF2E7D32)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Nama & Role
                  const Text(
                    nama,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      role,
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            // --- BAGIAN CONTENT ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // JUDUL SEKSI 1
                  const Text(
                    "Informasi Usaha",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  
                  // KARTU INFORMASI PETERNAKAN
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildProfileItem(Icons.badge, "ID Registrasi", idPeternak),
                        const Divider(height: 1, indent: 60, endIndent: 20),
                        
                        _buildProfileItem(Icons.store, "Nama Kandang", namaKandang),
                        const Divider(height: 1, indent: 60, endIndent: 20),
                        
                        _buildProfileItem(Icons.location_on, "Lokasi", lokasi),
                        // Spesialisasi SUDAH DIHAPUS dari sini
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  
                  // JUDUL SEKSI 2
                  const Text(
                    "Kontak & Akun",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),

                  // KARTU KONTAK
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildProfileItem(Icons.phone, "WhatsApp / Telp", noHp),
                        const Divider(height: 1, indent: 60, endIndent: 20),
                        
                        // Menu Pengaturan
                        _buildSettingsItem(context, Icons.settings, "Pengaturan Akun", () {}),
                        const Divider(height: 1, indent: 60, endIndent: 20),
                        
                        _buildSettingsItem(context, Icons.info_outline, "Tentang Aplikasi", () => _showAboutDialog(context)),
                        const Divider(height: 1, indent: 60, endIndent: 20),
                        
                        // Tombol Logout (Merah)
                        _buildSettingsItem(context, Icons.logout, "Keluar", () => _showLogoutDialog(context), isDestructive: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Lahan Ternak App v1.0.0",
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---
  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1), 
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF2E7D32), size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isDestructive ? Colors.red : Colors.grey[700], size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black87,
          fontSize: 15
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Keluar"),
        content: const Text("Yakin ingin keluar dari akun peternakan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil Keluar")));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.pets, color: Color(0xFF2E7D32)),
            SizedBox(width: 10),
            Text("Lahan Ternak"),
          ],
        ),
        content: const Text("Aplikasi manajemen kandang untuk memantau ternak secara digital."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Tutup")),
        ],
      ),
    );
  }
}