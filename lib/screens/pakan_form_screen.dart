import 'package:flutter/material.dart';
import '../models/pakan.dart';
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
  final TextEditingController _kuantitasController = TextEditingController();
  final TextEditingController _biayaController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  bool _isSaving = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime.now(),
      // Menyesuaikan tema Kalender jadi Hijau
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32), // HIJAU
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _tanggalController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}");
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      Pakan dataInput = Pakan(
        jenisPakan: _jenisController.text,
        kuantitas: _kuantitasController.text,
        biaya: _biayaController.text,
        tanggal: _tanggalController.text,
        keterangan: _keteranganController.text,
      );

      final success = await apiService.createPakan(dataInput);

      setState(() => _isSaving = false);
      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stok pakan berhasil dicatat!'), backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catat Stok Pakan"),
        backgroundColor: const Color(0xFF2E7D32), // HIJAU (Konsisten)
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Jenis Pakan (cth: Konsentrat)", _jenisController, icon: Icons.category),
              const SizedBox(height: 16),
              _buildTextField("Kuantitas (Kg)", _kuantitasController, icon: Icons.scale, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField("Biaya Pembelian (Rp)", _biayaController, icon: Icons.attach_money, isNumber: true),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tanggalController, readOnly: true, onTap: () => _selectDate(context),
                decoration: InputDecoration(labelText: "Tanggal Masuk", prefixIcon: const Icon(Icons.calendar_today), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: Colors.grey[50]),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null
              ),
              const SizedBox(height: 16),
              _buildTextField("Keterangan", _keteranganController, icon: Icons.note, isRequired: false),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity, 
                height: 50, 
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submitForm, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32), // HIJAU (Konsisten)
                    foregroundColor: Colors.white
                  ), 
                  child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text("SIMPAN DATA", style: TextStyle(fontWeight: FontWeight.bold))
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {required IconData icon, bool isRequired = true, bool isNumber = false}) {
    return TextFormField(controller: controller, keyboardType: isNumber ? TextInputType.number : TextInputType.text, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: Colors.grey[50]), validator: isRequired ? (val) => val!.isEmpty ? '$label kosong' : null : null);
  }
}