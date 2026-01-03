import 'package:flutter/material.dart';
import '../models/kesehatan.dart';
import '../services/api_service.dart';
import 'kesehatan_form_screen.dart';

class KesehatanListScreen extends StatefulWidget {
  const KesehatanListScreen({super.key});

  @override
  State<KesehatanListScreen> createState() => _KesehatanListScreenState();
}

class _KesehatanListScreenState extends State<KesehatanListScreen> {
  final ApiService apiService = ApiService();
  
  // Gunakan Future nullable untuk mencegah error LateInitialization
  Future<List<Kesehatan>>? futureKesehatan;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Load data saat pertama kali buka
  }

  void _fetchData() {
    setState(() {
      futureKesehatan = apiService.fetchKesehatan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: RefreshIndicator(
        onRefresh: () async => _fetchData(),
        child: FutureBuilder<List<Kesehatan>>(
          future: futureKesehatan,
          builder: (context, snapshot) {
            // 1. Loading State
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } 
            // 2. Error State
            else if (snapshot.hasError) {
              return Center(child: Text("Gagal memuat data:\n${snapshot.error}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)));
            } 
            // 3. Empty State
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Belum ada data riwayat kesehatan"));
            }

            // 4. Data Ada -> Tampilkan List
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                    border: Border(left: BorderSide(color: const Color(0xFF2E7D32), width: 4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ID Ternak: ${item.idTernak}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              // TAMPILKAN TANGGAL (Pastikan variabel 'tanggalPeriksa' benar)
                              item.tanggalPeriksa,
                              style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      
                      // --- PERBAIKAN DI SINI: Gunakan variabel model yang baru ---
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.sick, size: 18, color: Colors.orange),
                          const SizedBox(width: 8),
                          // Ganti 'keluhan' jadi 'diagnosa'
                          Expanded(child: Text("Diagnosa: ${item.diagnosa}", style: const TextStyle(fontWeight: FontWeight.w500))),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.medical_services, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          // Ganti 'catatan' jadi 'tindakan'
                          Expanded(child: Text("Tindakan: ${item.tindakan}")),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.medication, size: 18, color: Colors.purple),
                          const SizedBox(width: 8),
                          Expanded(child: Text("Obat: ${item.obat}", style: const TextStyle(color: Colors.grey))),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigasi ke Form
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KesehatanFormScreen()),
          );

          // PENTING: Jika kembali dengan hasil 'true', Refresh Data!
          if (result == true) {
            _fetchData();
          }
        },
        label: const Text("Catat Data", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_circle),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
    );
  }
}