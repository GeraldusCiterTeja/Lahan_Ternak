import 'package:flutter/material.dart';
import '../models/kesehatan.dart';
import '../models/ternak.dart';
import '../services/api_service.dart';

class KesehatanFormScreen extends StatefulWidget {
  const KesehatanFormScreen({super.key});

  @override
  State<KesehatanFormScreen> createState() => _KesehatanFormScreenState();
}

class _KesehatanFormScreenState extends State<KesehatanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  // Ubah nama variabel controller biar tidak bingung
  final TextEditingController _diagnosaController = TextEditingController(); // Dulu keluhan
  final TextEditingController _obatController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _tindakanController = TextEditingController(); // Dulu catatan

  List<Ternak> _ternakList = [];
  String? _selectedKodeTag;
  bool _isLoadingTernak = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadTernak();
  }

  Future<void> _loadTernak() async {
    try {
      final list = await apiService.fetchTernak();
      setState(() {
        _ternakList = list;
        _isLoadingTernak = false;
      });
    } catch (e) {
      setState(() => _isLoadingTernak = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now(),
      builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D32), onPrimary: Colors.white)), child: child!),
    );
    if (picked != null) {
      setState(() {
        _tanggalController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      // Pastikan data yang dikirim sesuai Model baru
      Kesehatan dataInput = Kesehatan(
        idTernak: _selectedKodeTag!, 
        diagnosa: _diagnosaController.text, // Kirim ke kolom diagnosa
        obat: _obatController.text,
        tanggalPeriksa: _tanggalController.text, // Kirim ke kolom tanggal_periksa
        tindakan: _tindakanController.text.isEmpty ? '-' : _tindakanController.text, // Kirim ke kolom tindakan
      );

      final success = await apiService.createKesehatan(dataInput);

      setState(() => _isSaving = false);
      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil disimpan!'), backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan data'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catat Riwayat Kesehatan"), backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _isLoadingTernak ? const CircularProgressIndicator() : DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Pilih Ternak", prefixIcon: const Icon(Icons.pets), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: Colors.grey[50]),
                value: _selectedKodeTag,
                items: _ternakList.map((ternak) => DropdownMenuItem(value: ternak.kodeTag, child: Text("${ternak.kodeTag} - ${ternak.jenisTernak}"))).toList(),
                onChanged: (val) => setState(() => _selectedKodeTag = val),
                validator: (val) => val == null ? 'Pilih ternak' : null,
              ),
              const SizedBox(height: 16),
              
              // Input Diagnosa
              _buildTextField("Diagnosa / Penyakit", _diagnosaController, icon: Icons.sick),
              const SizedBox(height: 16),
              
              // Input Tindakan
              _buildTextField("Tindakan Penanganan", _tindakanController, icon: Icons.medical_services),
              const SizedBox(height: 16),
              
              // Input Obat
              _buildTextField("Obat Diberikan", _obatController, icon: Icons.medication),
              const SizedBox(height: 16),
              
              _buildDatePickerField("Tanggal Periksa", _tanggalController, context),
              const SizedBox(height: 24),
              
              SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _isSaving ? null : _submitForm, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white), child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text("SIMPAN DATA", style: TextStyle(fontWeight: FontWeight.bold)))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {required IconData icon}) {
    return TextFormField(controller: controller, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: Colors.grey[50]), validator: (val) => val!.isEmpty ? '$label kosong' : null);
  }
  
  Widget _buildDatePickerField(String label, TextEditingController controller, BuildContext context) {
    return TextFormField(controller: controller, readOnly: true, onTap: () => _selectDate(context), decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.calendar_today), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: Colors.grey[50]), validator: (val) => val!.isEmpty ? 'Pilih tanggal' : null);
  }
}