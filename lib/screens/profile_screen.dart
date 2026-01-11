import 'dart:io';
import 'package:flutter/foundation.dart'; // Wajib untuk Web
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variabel Data
  String idUser = "";
  String namaUser = "Memuat...";
  String emailUser = "...";
  String namaKandang = "...";
  String lokasi = "...";
  String idRegistrasi = "...";
  String? fotoProfil;

  final ApiService _apiService = ApiService();
  
  // URL untuk Web (Localhost)
  final String _baseUrlImage = "http://localhost/lahan_ternak_api/uploads/";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = prefs.getString('id_user') ?? "0";
      namaUser = prefs.getString('nama_lengkap') ?? "User";
      emailUser = prefs.getString('username') ?? "-";
      namaKandang = prefs.getString('nama_kandang') ?? "Belum diset";
      lokasi = prefs.getString('lokasi') ?? "-";
      idRegistrasi = prefs.getString('id_registrasi') ?? "-";
      fotoProfil = prefs.getString('foto_profil');
    });
  }

  // --- 1. PROSES UPDATE DATABASE ---
  Future<void> _processUpdate(String nama, String kandang, String lokasi, File? foto) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sedang menyimpan data..."), duration: Duration(seconds: 1)),
    );

    final result = await _apiService.updateProfile(idUser, nama, kandang, lokasi, foto);

    if (!mounted) return;

    if (result['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      final user = result['user'];
      
      await prefs.setString('nama_lengkap', user['nama_lengkap']);
      await prefs.setString('nama_kandang', user['nama_kandang']);
      await prefs.setString('lokasi', user['lokasi']);
      
      if (user['foto_profil'] != null) {
        await prefs.setString('foto_profil', user['foto_profil']);
      }

      _loadUserData(); // Refresh tampilan
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil diupdate!"), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: ${result['message']}"), backgroundColor: Colors.red),
      );
    }
  }

  // --- 2. DIALOG EDIT PROFIL ---
  void _showEditDialog() async {
    final txtNama = TextEditingController(text: namaUser);
    final txtKandang = TextEditingController(text: namaKandang);
    final txtLokasi = TextEditingController(text: lokasi);
    File? imageFile;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          
          // Logika Preview Image (Web vs Mobile)
          ImageProvider? previewImage;
          if (imageFile != null) {
            previewImage = kIsWeb 
                ? NetworkImage(imageFile!.path) 
                : FileImage(imageFile!);
          }

          return AlertDialog(
            title: const Text("Edit Profil"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(source: ImageSource.gallery);
                      if (picked != null) {
                        setModalState(() => imageFile = File(picked.path));
                      }
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: previewImage,
                          child: imageFile == null 
                            ? const Icon(Icons.person, size: 40, color: Colors.grey) 
                            : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(controller: txtNama, decoration: const InputDecoration(labelText: "Nama Lengkap")),
                  TextField(controller: txtKandang, decoration: const InputDecoration(labelText: "Nama Kandang")),
                  TextField(controller: txtLokasi, decoration: const InputDecoration(labelText: "Lokasi")),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'nama': txtNama.text, 
                    'kandang': txtKandang.text, 
                    'lokasi': txtLokasi.text, 
                    'foto': imageFile
                  });
                },
                child: const Text("Simpan"),
              )
            ],
          );
        },
      ),
    );

    if (result != null) {
      _processUpdate(result['nama'], result['kandang'], result['lokasi'], result['foto']);
    }
  }

  // --- 3. DIALOG TENTANG APLIKASI (INI YANG TADI HILANG) ---
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: const [
            Icon(Icons.info_outline, color: Color(0xFF2E7D32)),
            SizedBox(width: 10),
            Text("Tentang Aplikasi"),
          ],
        ),
        content: const Text(
          "Lahan Ternak App\n\n"
          "Aplikasi manajemen kandang modern untuk:\n"
          "• Pencatatan Populasi\n"
          "• Monitoring Kesehatan\n"
          "• Manajemen Pakan\n",
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Tutup", style: TextStyle(color: Color(0xFF2E7D32))),
          ),
        ],
      ),
    );
  }

  // --- 4. FUNGSI LOGOUT (INI JUGA TADI HILANG) ---
  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Keluar Akun?"),
        content: const Text("Anda harus login kembali untuk mengakses data."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text("Keluar")
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40, left: 20, right: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: (fotoProfil != null && fotoProfil!.isNotEmpty) 
                        ? NetworkImage("$_baseUrlImage$fotoProfil") 
                        : null,
                    child: (fotoProfil == null || fotoProfil!.isEmpty) 
                        ? const Icon(Icons.person, size: 60, color: Color(0xFF2E7D32)) 
                        : null,
                  ),
                  const SizedBox(height: 15),
                  Text(namaUser, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("@$emailUser", style: const TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // CARD INFO KANDANG
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Informasi Kandang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)]),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.store, "Nama Kandang", namaKandang),
                            const Divider(),
                            _buildInfoRow(Icons.badge, "ID Registrasi", idRegistrasi),
                            const Divider(),
                            _buildInfoRow(Icons.location_on, "Lokasi", lokasi),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 25),

                  // CARD PENGATURAN & LAINNYA
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Pengaturan & Lainnya", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)]),
                        child: Column(
                          children: [
                            ListTile(
                              leading: _buildIconBox(Icons.edit, Colors.blue),
                              title: const Text("Edit Profil"),
                              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                              onTap: _showEditDialog,
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: _buildIconBox(Icons.info_outline, Colors.orange),
                              title: const Text("Tentang Aplikasi"),
                              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                              onTap: _showAboutDialog, // Sekarang fungsi ini sudah ada isinya
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: _buildIconBox(Icons.logout, Colors.red),
                              title: const Text("Keluar Akun", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              onTap: () => _logout(context), // Sekarang fungsi ini sudah ada isinya
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  
                  // VERSI APP
                  Column(
                    children: [
                      const Text("Lahan Ternak App", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("Versi 1.0.0", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                    ],
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

  // Helper Widget
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2E7D32), size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconBox(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8), 
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), 
      child: Icon(icon, color: color)
    );
  }
}