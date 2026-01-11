import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  bool _isLoading = false;
  bool _isObscure = true;

Future<void> _handleLogin() async {
    // ... (validasi input & loading state) ...

    final api = ApiService();
    final result = await api.login(_userController.text, _passController.text);

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      
      // DATA DARI SQL (Disimpan ke HP)
      if (result['user'] != null) {
        final user = result['user'];

        // 1. ID User (Penting untuk Update Profil)
        await prefs.setString('id_user', user['id_user'].toString());

        // 2. Info Dasar
        await prefs.setString('username', user['username'] ?? '');
        await prefs.setString('nama_lengkap', user['nama_lengkap'] ?? '');
        
        // 3. Info Kandang (Sesuai SQL Anda)
        await prefs.setString('nama_kandang', user['nama_kandang'] ?? 'Peternakan Rakyat');
        await prefs.setString('lokasi', user['lokasi'] ?? '-');
        await prefs.setString('id_registrasi', user['id_registrasi'] ?? '-');

        // 4. Foto Profil (Cek jika null di database)
        if (user['foto_profil'] != null && user['foto_profil'] != "") {
          await prefs.setString('foto_profil', user['foto_profil']);
        } else {
          await prefs.remove('foto_profil'); // Hapus jika kosong
        }
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      // ... (error handling) ...
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const Icon(Icons.pets, size: 80, color: Color(0xFF2E7D32)),
              const SizedBox(height: 16),
              const Text(
                "Lahan Ternak",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
              ),
              const Text("Masuk untuk mengelola peternakan", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),

              // Input Username
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF2E7D32)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Input Password
              TextField(
                controller: _passController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF2E7D32)),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Login
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("MASUK", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),

              // Tombol Daftar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text("Daftar disini", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}