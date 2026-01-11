import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'package:flutter/foundation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller
  final _namaController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _kandangController = TextEditingController();
  final _lokasiController = TextEditingController();
  
  // Variabel Foto
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _handleRegister() async {
    if (_namaController.text.isEmpty || 
        _userController.text.isEmpty || 
        _passController.text.isEmpty ||
        _kandangController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap isi semua data wajib!'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);

    final api = ApiService();
    final result = await api.register(
      _namaController.text,
      _userController.text,
      _passController.text,
      _kandangController.text,
      _lokasiController.text,
      _imageFile 
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil! Silakan Login.'), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Akun Peternakan"), 
        backgroundColor: Colors.white, 
        foregroundColor: const Color(0xFF2E7D32), 
        elevation: 0
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.add_business, size: 60, color: Color(0xFF2E7D32)),
            const SizedBox(height: 20),

            // === BAGIAN 1: INFORMASI AKUN ===
            const Text("Informasi Akun", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            
            _buildTextField("Nama Pemilik", _namaController, Icons.person),
            const SizedBox(height: 10),
            _buildTextField("Username Login", _userController, Icons.account_circle),
            const SizedBox(height: 10),
            _buildTextField("Password", _passController, Icons.lock, isPassword: true),
            
            const SizedBox(height: 10),
            
            // --- AREA UPLOAD FOTO (DESAIN DISAMAKAN) ---
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                // Agar tinggi kotaknya mirip dengan TextField
                constraints: const BoxConstraints(minHeight: 55),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // Menggunakan warna border yang lebih gelap (black54) agar sama dengan TextField
                  border: Border.all(color: Colors.black45), 
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Row(
                  children: [
                    // Ikon Kamera (Warna HIJAU, sama seperti ikon input lain)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _imageFile != null 
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: kIsWeb
                              ? Image.network(_imageFile!.path, width: 40, height: 40, fit: BoxFit.cover) // Jika Web
                              : Image.file(_imageFile!, width: 40, height: 40, fit: BoxFit.cover),        // Jika HP
                          )
                        : const Icon(Icons.camera_alt, color: Color(0xFF2E7D32)), // Ikon Hijau
                    ),
                    
                    // Teks Label
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _imageFile != null ? "Foto Terpilih" : "Foto Profil (Opsional)",
                            style: TextStyle(
                              fontSize: 16, // Ukuran font disamakan dengan inputan
                              color: _imageFile != null ? Colors.black : Colors.black54, // Warna teks disamakan
                            )
                          ),
                          if (_imageFile == null)
                            const Text(
                              "Ketuk untuk buka galeri",
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                    
                    if (_imageFile != null)
                      const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
            ),
            // ----------------------------------------

            const Divider(height: 30),

            // === BAGIAN 2: INFORMASI PETERNAKAN ===
            const Text("Informasi Peternakan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            
            _buildTextField("Nama Kandang", _kandangController, Icons.store),
            const SizedBox(height: 10),
            _buildTextField("Lokasi (Kecamatan/Desa)", _lokasiController, Icons.location_on),
            
            const SizedBox(height: 30),
            
            // TOMBOL DAFTAR
            SizedBox(
              width: double.infinity, 
              height: 50, 
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister, 
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white), 
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("DAFTAR SEKARANG")
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label, 
        // Warna label default disamakan
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
        // Border Default (Saat tidak diklik)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black45), // Warna border disamakan
        ),
        // Border Fokus (Saat diklik)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
    );
  }
}