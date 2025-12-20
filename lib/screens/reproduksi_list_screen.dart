import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'reproduksi_form_screen.dart'; // Nanti dibuat

class ReproduksiListScreen extends StatefulWidget {
  const ReproduksiListScreen({super.key});

  @override
  State<ReproduksiListScreen> createState() => _ReproduksiListScreenState();
}

class _ReproduksiListScreenState extends State<ReproduksiListScreen> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.fetchReproduksi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Belum ada catatan reproduksi."));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.favorite_rounded, color: Colors.pinkAccent),
                  title: Text("${item['kode_tag']} - ${item['jenis_kejadian']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Tanggal: ${item['tanggal_kejadian']}\nKet: ${item['keterangan']}"),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (c) => const ReproduksiFormScreen()));
          if (res == true) setState(() {});
        },
        label: const Text("Catat Siklus"),
        icon: const Icon(Icons.child_care_rounded),
      ),
    );
  }
}