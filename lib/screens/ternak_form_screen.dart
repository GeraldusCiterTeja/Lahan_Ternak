import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ternak.dart';
import '../services/api_service.dart';

class TernakFormScreen extends StatefulWidget {
  final Ternak? ternak;
  const TernakFormScreen({super.key, this.ternak});

  @override
  State<TernakFormScreen> createState() => _TernakFormScreenState();
}

class _TernakFormScreenState extends State<TernakFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  late TextEditingController _kodeTagController;
  late TextEditingController _jenisTernakController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _silsilahController;
  
  String _jenisKelamin = 'Jantan';
  String _status = 'Aktif';

  @override
  void initState() {
    super.initState();
    final isEditing = widget.ternak != null;
    _kodeTagController = TextEditingController(text: isEditing ? widget.ternak!.kodeTag : '');
    _jenisTernakController = TextEditingController(text: isEditing ? widget.ternak!.jenisTernak : '');
    _tanggalLahirController = TextEditingController(text: isEditing ? widget.ternak!.tanggalLahir : '');
    _silsilahController = TextEditingController(text: isEditing ? widget.ternak!.silsilah : '');
    if (isEditing) {
      _jenisKelamin = widget.ternak!.jenisKelamin;
      _status = widget.ternak!.status;
    }
  }

  @override
  void dispose() {
    _kodeTagController.dispose();
    _jenisTernakController.dispose();
    _tanggalLahirController.dispose();
    _silsilahController.dispose();
    super.dispose();
  }

  // --- FUNGSI SAVE TERNAK ---
  void _saveTernak() async {
    // 1. Validasi Input
    if (!_formKey.currentState!.validate()) return;
    
    // 2. Tampilkan Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // 3. Siapkan Objek Data
    final dataTernak = Ternak(
      idTernak: widget.ternak?.idTernak, 
      kodeTag: _kodeTagController.text,
      jenisTernak: _jenisTernakController.text,
      tanggalLahir: _tanggalLahirController.text,
      silsilah: _silsilahController.text.isEmpty ? null : _silsilahController.text,
      jenisKelamin: _jenisKelamin,
      status: _status,
    );

    bool success;
    // 4. Panggil API (Create atau Update)
    if (widget.ternak == null) {
      success = await apiService.createTernak(dataTernak);
    } else {
      success = await apiService.updateTernak(dataTernak);
    }

    if (!mounted) return;
    Navigator.pop(context); // Tutup Loading

    // 5. Tangani Hasil Respon
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil ${widget.ternak == null ? 'menambahkan' : 'memperbarui'} data!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Kembali ke List & Refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan data ke server.'),
          backgroundColor: Colors.red,
        ),
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
    final isEditing = widget.ternak != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Data Ternak' : 'Tambah Ternak'),
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
                      TextFormField(
                        controller: _kodeTagController,
                        decoration: _inputDecor('Kode Tag', Icons.qr_code_scanner_rounded),
                        validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _jenisTernakController,
                        decoration: _inputDecor('Jenis Ternak', Icons.pets_rounded),
                        validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _tanggalLahirController,
                        readOnly: true,
                        decoration: _inputDecor('Tanggal Lahir', Icons.calendar_today_rounded),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked));
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      // Ikon Jenis Kelamin yang Relevan
                      DropdownButtonFormField<String>(
                        value: _jenisKelamin,
                        decoration: _inputDecor('Jenis Kelamin', Icons.transgender_rounded),
                        items: ['Jantan', 'Betina'].map((s) => DropdownMenuItem(
                          value: s, child: Text(s)
                        )).toList(),
                        onChanged: (v) => setState(() => _jenisKelamin = v!),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Tombol Simpan/Tambah Dinamis
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: _saveTernak, 
                  child: Text(
                    isEditing ? 'SIMPAN PERUBAHAN' : 'TAMBAH TERNAK', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}