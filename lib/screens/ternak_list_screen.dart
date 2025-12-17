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

  void _fetchTernak() {
    Future<List<Ternak>> dataDariApi = apiService.fetchTernak();

    // 2. Gunakan setState HANYA untuk memperbarui variabel state
    setState(() {
      futureTernak = dataDariApi;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTernak();
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
                padding: const EdgeInsets.only(top: 10, bottom: 80),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => _buildModernCard(snapshot.data![index]),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => const TernakFormScreen()));
          if (res == true) _fetchTernak();
        },
        label: const Text("Tambah Ternak", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.3,
            child: Image.asset('assets/logo_app.png', width: 120, errorBuilder: (c, e, s) => const Icon(Icons.pets, size: 80)),
          ),
          const SizedBox(height: 20),
          const Text("Belum ada data ternak", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildModernCard(Ternak ternak) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade50,
          child: Text(ternak.kodeTag.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        title: Text(ternak.kodeTag, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text("${ternak.jenisTernak} • ${ternak.jenisKelamin}"),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: ternak.status == 'Aktif' ? Colors.green.shade50 : Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(ternak.status, style: TextStyle(color: ternak.status == 'Aktif' ? Colors.green : Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        onTap: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => TernakFormScreen(ternak: ternak)));
          if (res == true) _fetchTernak();
        },
      ),
    );
  }
}