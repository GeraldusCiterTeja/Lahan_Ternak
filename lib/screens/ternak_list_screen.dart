import 'package:flutter/material.dart';
import '../models/ternak.dart';
import '../services/api_service.dart';
import 'ternak_form_screen.dart';
import 'ternak_detail_screen.dart';

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

  void _fetchTernak() {
    setState(() {
      futureTernak = apiService.fetchTernak();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      // Tombol Tambah
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TernakFormScreen()),
          );
          if (res == true) _fetchTernak();
        },
        label: const Text("Tambah", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      
      body: RefreshIndicator(
        onRefresh: () async => _fetchTernak(),
        child: FutureBuilder<List<Ternak>>(
          future: futureTernak,
          builder: (context, snapshot) {
            // 1. Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } 
            
            // 2. Error (PENTING: Tampilkan pesan errornya)
            else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 50, color: Colors.red),
                      const SizedBox(height: 10),
                      Text("Terjadi Kesalahan:\n${snapshot.error}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: _fetchTernak, child: const Text("Coba Lagi"))
                    ],
                  ),
                ),
              );
            } 
            
            // 3. Data Kosong
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Belum ada data ternak"));
            } 
            
            // 4. Ada Data (Render List)
            else {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => _buildCleanCard(snapshot.data![index]),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCleanCard(Ternak ternak) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TernakDetailScreen(
                  ternak: ternak,
                  onRefresh: _fetchTernak,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.inventory_2, color: Color(0xFF2E7D32)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ternak.kodeTag, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text("${ternak.jenisTernak} • ${ternak.jenisKelamin}", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ternak.status == 'Aktif' ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(ternak.status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ternak.status == 'Aktif' ? Colors.green : Colors.red)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}