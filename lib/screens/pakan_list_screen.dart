import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'pakan_form_screen.dart';

class PakanListScreen extends StatefulWidget {
  const PakanListScreen({super.key});

  @override
  State<PakanListScreen> createState() => _PakanListScreenState();
}

class _PakanListScreenState extends State<PakanListScreen> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.fetchPakan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Belum ada catatan pakan."));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.grass_rounded, color: Colors.green),
                  title: Text("${item['jenis_pakan']} (${item['kuantitas_kg']} Kg)", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Biaya: Rp ${item['biaya_rp']}\nTanggal: ${item['tanggal_input']}"),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (c) => const PakanFormScreen()));
          if (res == true) setState(() {});
        },
        label: const Text("Input Pakan"),
        icon: const Icon(Icons.add_shopping_cart_rounded),
      ),
    );
  }
}