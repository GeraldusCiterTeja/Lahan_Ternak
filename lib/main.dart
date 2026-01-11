import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Status Login (Null = sedang mengecek, True = sudah login, False = belum)
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Fungsi Cek Login di Memori HP
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getBool('is_logged_in') ?? false;
    
    setState(() {
      _isLoggedIn = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan Loading putih saat sedang mengecek
    if (_isLoggedIn == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lahan Ternak App',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      // LOGIKA UTAMA:
      // Jika sudah login -> Dashboard
      // Jika belum -> LoginScreen
      home: _isLoggedIn! ? const DashboardScreen() : const LoginScreen(),
    );
  }
}