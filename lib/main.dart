import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const LahanTernakApp());
}

class LahanTernakApp extends StatefulWidget {
  const LahanTernakApp({super.key});

  static _LahanTernakAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_LahanTernakAppState>();

  @override
  State<LahanTernakApp> createState() => _LahanTernakAppState();
}

class _LahanTernakAppState extends State<LahanTernakApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lahan Ternak App',
      debugShowCheckedModeBanner: false,
      
      // --- TEMA TERANG (Light Theme) ---
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
          surface: const Color(0xFFF8FAF8),
          brightness: Brightness.light,
        ),
        // PERBAIKAN: Gunakan CardThemeData di sini
        cardTheme: CardThemeData( 
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          color: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
      ),

      // --- TEMA GELAP (Dark Theme) ---
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.dark,
        ),
        // PERBAIKAN: Gunakan CardThemeData di sini
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white10),
          ),
          color: const Color(0xFF1E1E1E), // Warna card di mode gelap
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
      ),

      themeMode: _themeMode, 
      home: const DashboardScreen(),
    );
  }
}