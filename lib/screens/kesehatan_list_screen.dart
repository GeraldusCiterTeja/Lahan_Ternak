import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'kesehatan_form_screen.dart';

class KesehatanListScreen extends StatefulWidget {
  const KesehatanListScreen({super.key});

  @override
  State<KesehatanListScreen> createState() => _KesehatanListScreenState();
}

class _KesehatanListScreenState extends State<KesehatanListScreen> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.fetchKesehatan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada riwayat kesehatan."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.medication_liquid_rounded, color: Colors.redAccent),
                  title: Text("${item['kode_tag']} - ${item['diagnosa']}", 
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Tindakan: ${item['tindakan']}\nTanggal: ${item['tanggal_periksa']}"),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const KesehatanFormScreen())
          );
          if (res == true) setState(() {}); // Refresh data setelah simpan
        },
        label: const Text("Catat Medis"),
        icon: const Icon(Icons.add_moderator_rounded),
      ),
    );
  }
}