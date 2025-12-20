import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class PakanFormScreen extends StatefulWidget {
  const PakanFormScreen({super.key});

  @override
  State<PakanFormScreen> createState() => _PakanFormScreenState();
}

class _PakanFormScreenState extends State<PakanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  final TextEditingController _jenisController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _biayaController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Default tanggal hari ini
    _tanggalController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _jenisController.dispose();
    _qtyController.dispose();
    _biayaController.dispose();
    _keteranganController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  void _simpanPakan() async {
    if (!_formKey.currentState!.validate()) return;

    // Tampilkan loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final data = {
      "tanggal_input": _tanggalController.text,
      "jenis_pakan": _jenisController.text,
      "kuantitas_kg": _qtyController.text,
      "biaya_rp": _biayaController.text,
      "keterangan": _keteranganController.text,
    };

    final success = await apiService.createPakan(data);

    if (!mounted) return;
    Navigator.pop(context); // Tutup loading

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan pakan berhasil disimpan!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true); // Kembali ke list & refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data pakan.'), backgroundColor: Colors.red),
      );
    }
  }

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
        title: const Text("Input Log Pakan"),
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
                      // Input Tanggal
                      TextFormField(
                        controller: _tanggalController,
                        readOnly: true,
                        decoration: _inputDecor('Tanggal Transaksi', Icons.calendar_month_rounded),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _tanggalController.text = DateFormat('yyyy-MM-dd').format(picked));
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      
                      // Input Jenis Pakan
                      TextFormField(
                        controller: _jenisController,
                        decoration: _inputDecor('Jenis Pakan', Icons.grass_rounded),
                        validator: (v) => v!.isEmpty ? 'Jenis pakan wajib diisi' : null,
                      ),
                      const SizedBox(height: 18),

                      // Input Kuantitas (Kg)
                      TextFormField(
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecor('Jumlah (Kg)', Icons.scale_rounded),
                        validator: (v) => v!.isEmpty ? 'Jumlah wajib diisi' : null,
                      ),
                      const SizedBox(height: 18),

                      // Input Biaya (Rp)
                      TextFormField(
                        controller: _biayaController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecor('Total Biaya (Rp)', Icons.payments_rounded),
                        validator: (v) => v!.isEmpty ? 'Biaya wajib diisi' : null,
                      ),
                      const SizedBox(height: 18),

                      // Input Keterangan
                      TextFormField(
                        controller: _keteranganController,
                        decoration: _inputDecor('Keterangan (Opsional)', Icons.description_rounded),
                        maxLines: 2,
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
                  onPressed: _simpanPakan,
                  child: const Text("SIMPAN LOG PAKAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}