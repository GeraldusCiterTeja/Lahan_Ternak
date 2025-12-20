import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/ternak.dart';

class ReproduksiFormScreen extends StatefulWidget {
  const ReproduksiFormScreen({super.key});

  @override
  State<ReproduksiFormScreen> createState() => _ReproduksiFormScreenState();
}

class _ReproduksiFormScreenState extends State<ReproduksiFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  // Controllers untuk input
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  // State untuk dropdown
  int? _selectedTernakId;
  String _jenisKejadian = 'Kawin'; // Default awal

  // Daftar ternak untuk dropdown
  List<Ternak> _daftarTernak = [];
  final List<String> _jenisKejadianOptions = ['Kawin', 'Hamil', 'Lahir', 'Gagal'];

  @override
  void initState() {
    super.initState();
    _loadDaftarTernak();
    _tanggalController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  // Ambil daftar ternak dari API untuk dropdown
  void _loadDaftarTernak() async {
    final data = await apiService.fetchTernak();
    setState(() {
      _daftarTernak = data;
      // Jika ada ternak, pilih yang pertama sebagai default
      if (_daftarTernak.isNotEmpty) {
        _selectedTernakId = _daftarTernak.first.idTernak;
      }
    });
  }

  // Fungsi untuk menyimpan data reproduksi
  void _simpanReproduksi() async {
    if (!_formKey.currentState!.validate() || _selectedTernakId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data.'), backgroundColor: Colors.red),
      );
      return;
    }

    // Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final data = {
      "id_ternak": _selectedTernakId,
      "tanggal_kejadian": _tanggalController.text,
      "jenis_kejadian": _jenisKejadian,
      "keterangan": _keteranganController.text,
    };

    final success = await apiService.createReproduksi(data);

    if (!mounted) return;
    Navigator.pop(context); // Tutup loading

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan reproduksi berhasil disimpan!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true); // Kembali ke list & refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data reproduksi.'), backgroundColor: Colors.red),
      );
    }
  }

  // Dekorasi Input Modern
  InputDecoration _inputDecor(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text("Catat Siklus Reproduksi"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Dropdown untuk memilih Ternak
                      DropdownButtonFormField<int>(
                        value: _selectedTernakId,
                        decoration: _inputDecor('Pilih Ternak', Icons.pets_rounded),
                        items: _daftarTernak.map((t) => DropdownMenuItem(
                          value: t.idTernak,
                          child: Text(t.kodeTag),
                        )).toList(),
                        onChanged: (val) => setState(() => _selectedTernakId = val),
                        validator: (v) => v == null ? 'Wajib pilih ternak' : null,
                      ),
                      const SizedBox(height: 18),
                      
                      // Input Tanggal Kejadian
                      TextFormField(
                        controller: _tanggalController,
                        readOnly: true,
                        decoration: _inputDecor('Tanggal Kejadian', Icons.calendar_month_rounded),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _tanggalController.text = DateFormat('yyyy-MM-dd').format(picked));
                          }
                        },
                        validator: (v) => v!.isEmpty ? 'Tanggal wajib diisi' : null,
                      ),
                      const SizedBox(height: 18),

                      // Dropdown Jenis Kejadian
                      DropdownButtonFormField<String>(
                        value: _jenisKejadian,
                        decoration: _inputDecor('Jenis Kejadian', Icons.category_rounded),
                        items: _jenisKejadianOptions.map((s) => DropdownMenuItem(
                          value: s, child: Text(s)
                        )).toList(),
                        onChanged: (val) => setState(() => _jenisKejadian = val!),
                      ),
                      const SizedBox(height: 18),

                      // Input Keterangan
                      TextFormField(
                        controller: _keteranganController,
                        decoration: _inputDecor('Keterangan (Opsional)', Icons.description_rounded),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: _simpanReproduksi,
                  child: const Text("SIMPAN CATATAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}