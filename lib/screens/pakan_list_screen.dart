import 'package:flutter/material.dart';
import '../models/pakan.dart';
import '../services/api_service.dart';
import 'pakan_form_screen.dart';

class PakanListScreen extends StatefulWidget {
  const PakanListScreen({super.key});

  @override
  State<PakanListScreen> createState() => _PakanListScreenState();
}

class _PakanListScreenState extends State<PakanListScreen> {
  final ApiService apiService = ApiService();
  
  // Gunakan nullable untuk mencegah error LateInitialization
  Future<List<Pakan>>? futurePakan;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      futurePakan = apiService.fetchPakan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: RefreshIndicator(
        onRefresh: () async => _fetchData(),
        child: FutureBuilder<List<Pakan>>(
          future: futurePakan,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Belum ada data pakan"));
            }

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
                      BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                    // Warna Hijau Konsisten
                    border: Border(left: BorderSide(color: const Color(0xFF2E7D32), width: 4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris 1: Judul & Tanggal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.jenisPakan, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(item.tanggal, style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const Divider(),
                      
                      // Baris 2: Kuantitas & Biaya
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Kuantitas", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text("${item.kuantitas} Kg", style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("Biaya", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text("Rp ${item.biaya}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                        ],
                      ),
                      
                      // Baris 3: Keterangan (Jika ada)
                      if (item.keterangan != '-' && item.keterangan.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text("Catatan: ${item.keterangan}", style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
                      ]
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
          final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => const PakanFormScreen()));
          if (res == true) _fetchData();
        },
        label: const Text("Catat Pakan"),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
    );
  }
}