import 'package:flutter/material.dart';
import '../models/ternak.dart';
import '../services/api_service.dart';

class TernakEditScreen extends StatefulWidget {
  final Ternak ternak; // Menerima data ternak yang akan diedit

  const TernakEditScreen({super.key, required this.ternak});

  @override
  State<TernakEditScreen> createState() => _TernakEditScreenState();
}

class _TernakEditScreenState extends State<TernakEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  late TextEditingController _kodeTagController;
  late TextEditingController _jenisTernakController;
  late TextEditingController _jenisKelaminController;
  late TextEditingController _faseController;
  late TextEditingController _beratController;
  late TextEditingController _tglLahirController;
  late TextEditingController _silsilahController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // ISI FORMULIR DENGAN DATA LAMA
    _kodeTagController = TextEditingController(text: widget.ternak.kodeTag);
    _jenisTernakController = TextEditingController(text: widget.ternak.jenisTernak);
    _jenisKelaminController = TextEditingController(text: widget.ternak.jenisKelamin);
    _faseController = TextEditingController(text: widget.ternak.fase);
    _beratController = TextEditingController(text: widget.ternak.berat);
    _tglLahirController = TextEditingController(text: widget.ternak.tanggalLahir);
    _silsilahController = TextEditingController(text: widget.ternak.silsilah);
  }

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

  // Fungsi Date Picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      // Menyesuaikan tema kalender agar hijau juga
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32), 
              onPrimary: Colors.white, 
              onSurface: Colors.black, 
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _tglLahirController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // BUNGKUS DATA (Sertakan ID Ternak agar API tahu mana yang diedit)
      Ternak dataUpdate = Ternak(
        idTernak: widget.ternak.idTernak, // PENTING: ID JANGAN HILANG
        kodeTag: _kodeTagController.text,
        jenisTernak: _jenisTernakController.text, // Manual Input
        jenisKelamin: _jenisKelaminController.text, // Pilihan
        status: widget.ternak.status, // Status biarkan tetap sama
        
        fase: _faseController.text.isEmpty ? '-' : _faseController.text, // Pilihan
        berat: _beratController.text.isEmpty ? '0' : _beratController.text,
        tanggalLahir: _tglLahirController.text.isEmpty ? '-' : _tglLahirController.text, // Date Picker
        silsilah: _silsilahController.text.isEmpty ? '-' : _silsilahController.text,
      );

      final success = await apiService.updateTernak(dataUpdate);

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true); // Kembali dengan sinyal sukses
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil diperbarui!'), backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal update data'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Data Ternak"),
        backgroundColor: const Color(0xFF2E7D32), // HIJAU (Konsisten)
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

              _buildTextField("Kode Tag", _kodeTagController, icon: Icons.qr_code),
              const SizedBox(height: 10),
              
              // INPUT MANUAL (Sesuai permintaan)
              _buildTextField("Jenis Ternak (cth: Sapi Limosin)", _jenisTernakController, icon: Icons.pets),
              const SizedBox(height: 10),
              
              // DROPDOWN
              _buildDropdownField(label: "Jenis Kelamin", controller: _jenisKelaminController, items: ["Jantan", "Betina"], icon: Icons.transgender),
              
              const SizedBox(height: 20),
              const Divider(),
              const Text("Informasi Tambahan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),

              // DROPDOWN
              _buildDropdownField(label: "Fase Ternak", controller: _faseController, items: ["Starter", "Grower", "Finisher"], icon: Icons.timeline, isRequired: false),
              const SizedBox(height: 10),
              
              _buildTextField("Berat (kg)", _beratController, icon: Icons.monitor_weight, isNumber: true),
              const SizedBox(height: 10),
              
              // DATE PICKER
              _buildDatePickerField("Tanggal Lahir", _tglLahirController, context),
              const SizedBox(height: 10),
              
              _buildTextField("Silsilah", _silsilahController, icon: Icons.family_restroom, isRequired: false),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32), // HIJAU (Konsisten)
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("UPDATE DATA", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---
  Widget _buildTextField(String label, TextEditingController controller, {required IconData icon, bool isRequired = true, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: Colors.grey[50]),
      validator: isRequired ? (val) => val == null || val.isEmpty ? '$label kosong' : null : null,
    );
  }

  Widget _buildDropdownField({required String label, required TextEditingController controller, required List<String> items, required IconData icon, bool isRequired = true}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: Colors.grey[50]),
      value: items.contains(controller.text) ? controller.text : null,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: (val) => setState(() => controller.text = val ?? ''),
      validator: isRequired ? (val) => val == null ? 'Pilih $label' : null : null,
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller, BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.calendar_today), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: Colors.grey[50]),
    );
  }
}