import 'package:flutter/material.dart';
import '../models/ternak.dart';
import '../services/api_service.dart';

class TernakFormScreen extends StatefulWidget {
  const TernakFormScreen({super.key});

  @override
  State<TernakFormScreen> createState() => _TernakFormScreenState();
}

class _TernakFormScreenState extends State<TernakFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  // --- CONTROLLERS ---
  final TextEditingController _kodeTagController = TextEditingController();
  final TextEditingController _jenisTernakController = TextEditingController(); // KETIK MANUAL
  final TextEditingController _jenisKelaminController = TextEditingController(); // DROPDOWN
  
  final TextEditingController _faseController = TextEditingController(); // DROPDOWN
  final TextEditingController _beratController = TextEditingController();
  final TextEditingController _tglLahirController = TextEditingController(); // DATE PICKER
  final TextEditingController _silsilahController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _kodeTagController.dispose();
    _jenisTernakController.dispose();
    _jenisKelaminController.dispose();
    _faseController.dispose();
    _beratController.dispose();
    _tglLahirController.dispose();
    _silsilahController.dispose();
    super.dispose();
  }

  // --- FUNGSI PEMILIH TANGGAL (DATE PICKER) ---
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        // Format ke YYYY-MM-DD
        String formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        _tglLahirController.text = formattedDate;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Ternak dataInput = Ternak(
        kodeTag: _kodeTagController.text,
        jenisTernak: _jenisTernakController.text, // Input Manual
        jenisKelamin: _jenisKelaminController.text, // Pilihan
        status: 'Aktif',
        
        fase: _faseController.text.isEmpty ? '-' : _faseController.text, // Pilihan
        berat: _beratController.text.isEmpty ? '0' : _beratController.text,
        tanggalLahir: _tglLahirController.text.isEmpty ? '-' : _tglLahirController.text,
        silsilah: _silsilahController.text.isEmpty ? '-' : _silsilahController.text,
      );

      final success = await apiService.createTernak(dataInput);

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ternak berhasil ditambahkan!'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan data'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Data Ternak"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Informasi Wajib", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              
              _buildTextField("Kode Tag (cth: SP-001)", _kodeTagController, icon: Icons.qr_code),
              const SizedBox(height: 10),
              
              // KEMBALI KE INPUT MANUAL
              _buildTextField("Jenis Ternak (cth: Sapi Limosin)", _jenisTernakController, icon: Icons.pets),
              const SizedBox(height: 10),

              // TETAP DROPDOWN (PILIHAN)
              _buildDropdownField(
                label: "Jenis Kelamin", 
                controller: _jenisKelaminController, 
                items: ["Jantan", "Betina"], 
                icon: Icons.transgender
              ),
              
              const SizedBox(height: 20),
              const Divider(),
              const Text("Informasi Tambahan (Opsional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),

              // TETAP DROPDOWN (PILIHAN)
              _buildDropdownField(
                label: "Fase Ternak", 
                controller: _faseController, 
                items: ["Starter", "Grower", "Finisher"], 
                icon: Icons.timeline,
                isRequired: false
              ),
              const SizedBox(height: 10),

              _buildTextField("Berat Awal (kg)", _beratController, icon: Icons.monitor_weight, isNumber: true, isRequired: false),
              const SizedBox(height: 10),

              // TETAP KALENDER
              _buildDatePickerField("Tanggal Lahir", _tglLahirController, context),
              
              const SizedBox(height: 10),
              _buildTextField("Silsilah / Indukan", _silsilahController, icon: Icons.family_restroom, isRequired: false),

              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("SIMPAN TERNAK", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER: TEXT FIELD BIASA ---
  Widget _buildTextField(String label, TextEditingController controller, {required IconData icon, bool isRequired = true, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: isRequired
          ? (value) {
              if (value == null || value.isEmpty) return '$label tidak boleh kosong';
              return null;
            }
          : null,
    );
  }

  // --- WIDGET HELPER: DROPDOWN (PILIHAN) ---
  Widget _buildDropdownField({
    required String label, 
    required TextEditingController controller, 
    required List<String> items, 
    required IconData icon,
    bool isRequired = true
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      value: controller.text.isNotEmpty && items.contains(controller.text) ? controller.text : null,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          controller.text = newValue ?? '';
        });
      },
      validator: isRequired
          ? (value) {
              if (value == null || value.isEmpty) return 'Pilih $label';
              return null;
            }
          : null,
    );
  }

  // --- WIDGET HELPER: DATE PICKER (KALENDER) ---
  Widget _buildDatePickerField(String label, TextEditingController controller, BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true, // Tidak bisa diketik manual
      onTap: () => _selectDate(context), // Buka kalender saat diklik
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}