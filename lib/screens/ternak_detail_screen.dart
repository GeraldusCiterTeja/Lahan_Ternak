import 'package:flutter/material.dart';
import '../models/ternak.dart';
import '../services/api_service.dart';
import 'ternak_edit_screen.dart'; // <--- JANGAN LUPA IMPORT INI

class TernakDetailScreen extends StatelessWidget {
  final Ternak ternak;
  final VoidCallback onRefresh;

  const TernakDetailScreen({
    super.key, 
    required this.ternak,
    required this.onRefresh,
  });

  void _deleteTernak(BuildContext context) async {
    // ... (Kode hapus sama seperti sebelumnya) ...
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Data?"),
        content: const Text("Data ini akan dihapus permanen."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final api = ApiService();
      if (ternak.idTernak != null) {
        bool success = await api.deleteTernak(ternak.idTernak!);
        if (success) {
          onRefresh();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menghapus data")));
        }
      }
    }
  }

  // FUNGSI NAVIGASI KE HALAMAN EDIT
  void _editTernak(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TernakEditScreen(ternak: ternak),
      ),
    );

    // Jika kembali dengan hasil 'true' (berhasil update), refresh data
    if (result == true) {
      onRefresh(); 
      Navigator.pop(context); // Opsional: tutup detail biar user klik lagi dari list yang baru
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Detail Ternak"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          // TOMBOL EDIT (PENSIL)
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Edit Data",
            onPressed: () => _editTernak(context),
          ),
          
          // TOMBOL HAPUS (SAMPAH)
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "Hapus Data",
            onPressed: () => _deleteTernak(context),
          )
        ],
      ),
      
      // ... (Bagian Body ke bawah SAMA PERSIS seperti sebelumnya) ...
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  const Icon(Icons.inventory_2, size: 60, color: Color(0xFF2E7D32)),
                  const SizedBox(height: 10),
                  Text(ternak.kodeTag, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                  const SizedBox(height: 5),
                  Text("${ternak.jenisTernak} • ${ternak.jenisKelamin}", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: ternak.status == 'Aktif' ? Colors.green[50] : Colors.red[50], borderRadius: BorderRadius.circular(20)),
                    child: Text(ternak.status, style: TextStyle(fontWeight: FontWeight.bold, color: ternak.status == 'Aktif' ? Colors.green : Colors.red)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Informasi Lengkap", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Divider(),
                  _buildDetailRow(Icons.timeline, "Fase", ternak.fase),
                  _buildDetailRow(Icons.monitor_weight, "Berat", "${ternak.berat} kg"),
                  _buildDetailRow(Icons.cake, "Tanggal Lahir", ternak.tanggalLahir),
                  _buildDetailRow(Icons.family_restroom, "Silsilah", ternak.silsilah),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400], size: 20),
          const SizedBox(width: 15),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }
}