import 'package:flutter/material.dart';
import '../models/ternak.dart';
import '../services/api_service.dart';
import 'ternak_form_screen.dart';

class TernakListScreen extends StatefulWidget {
  const TernakListScreen({super.key});

  @override
  State<TernakListScreen> createState() => _TernakListScreenState();
}

class _TernakListScreenState extends State<TernakListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Ternak>> futureTernak;

  @override
  void initState() {
    super.initState();
    _fetchTernak();
  }

  // Fungsi untuk mengambil data terbaru dari API
  void _fetchTernak() {
    final data = apiService.fetchTernak();
    setState(() {
      futureTernak = data;
    });
  }

  // Fungsi Konfirmasi Hapus yang aman dari error Deactivated Widget
  void _confirmDelete(Ternak ternak) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Data?"),
        content: Text("Apakah Anda yakin ingin menghapus ternak dengan kode ${ternak.kodeTag}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              // 1. Simpan referensi Navigator dan Messenger sebelum proses async
              final navigator = Navigator.of(context, rootNavigator: true);
              final messenger = ScaffoldMessenger.of(context);
              
              Navigator.pop(dialogContext); // Tutup dialog konfirmasi

              // 2. Tampilkan loading overlay
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );

              try {
                // 3. Eksekusi hapus di API
                bool success = await apiService.deleteTernak(ternak.idTernak!);
                
                // 4. Periksa apakah widget masih aktif (mounted) sebelum menggunakan context
                if (!mounted) return;
                
                // 5. Tutup loading overlay menggunakan referensi yang disimpan
                navigator.pop(); 

                if (success) {
                  _fetchTernak(); // Refresh daftar data
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text("Data berhasil dihapus"), 
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  throw Exception("Gagal menghapus data dari server");
                }
              } catch (e) {
                // Pastikan loading tertutup jika terjadi error
                if (mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text("Terjadi kesalahan: ${e.toString()}"), 
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: RefreshIndicator(
        onRefresh: () async => _fetchTernak(),
        child: FutureBuilder<List<Ternak>>(
          future: futureTernak,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            } else {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => _buildModernCard(snapshot.data![index]),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TernakFormScreen()),
          );
          if (res == true) _fetchTernak(); // Refresh jika kembali dari form
        },
        label: const Text("Tambah Ternak", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Center(
          child: Column(
            children: [
              Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/logo_app.png',
                  width: 150,
                  errorBuilder: (c, e, s) => const Icon(Icons.pets, size: 80, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Belum ada data ternak.", style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernCard(Ternak ternak) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade50,
          foregroundColor: const Color(0xFF2E7D32),
          child: const Icon(Icons.inventory_2_outlined),
        ),
        title: Text(
          ternak.kodeTag,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("${ternak.jenisTernak} • ${ternak.jenisKelamin}"),
            const SizedBox(height: 4),
            Text(
              ternak.status,
              style: TextStyle(
                color: ternak.status == 'Aktif' ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_note_rounded, color: Colors.blueGrey),
              onPressed: () async {
                final res = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TernakFormScreen(ternak: ternak)),
                );
                if (res == true) _fetchTernak();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              onPressed: () => _confirmDelete(ternak),
            ),
          ],
        ),
      ),
    );
  }
}