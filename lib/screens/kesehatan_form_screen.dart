import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/ternak.dart';

class KesehatanFormScreen extends StatefulWidget {
  const KesehatanFormScreen({super.key});

  @override
  State<KesehatanFormScreen> createState() => _KesehatanFormScreenState();
}

class _KesehatanFormScreenState extends State<KesehatanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  int? _selectedTernakId;
  final TextEditingController _diagnosaController = TextEditingController();
  final TextEditingController _tindakanController = TextEditingController();
  final TextEditingController _obatController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  List<Ternak> _daftarTernak = [];

  @override
  void initState() {
    super.initState();
    _loadDaftarTernak();
    _tanggalController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void _loadDaftarTernak() async {
    final data = await apiService.fetchTernak();
    setState(() => _daftarTernak = data);
  }

  void _simpanMedis() async {
    if (!_formKey.currentState!.validate() || _selectedTernakId == null) return;

    final data = {
      "id_ternak": _selectedTernakId,
      "tanggal_periksa": _tanggalController.text,
      "diagnosa": _diagnosaController.text,
      "tindakan": _tindakanController.text,
      "obat": _obatController.text,
    };

    final success = await apiService.createKesehatan(data);
    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catat Riwayat Medis")),
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
                      // Dropdown Pilih Ternak
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(labelText: "Pilih Ternak", prefixIcon: Icon(Icons.inventory)),
                        items: _daftarTernak.map((t) => DropdownMenuItem(
                          value: t.idTernak,
                          child: Text(t.kodeTag),
                        )).toList(),
                        onChanged: (val) => setState(() => _selectedTernakId = val),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _diagnosaController,
                        decoration: const InputDecoration(labelText: "Diagnosa", prefixIcon: Icon(Icons.coronavirus)),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _tindakanController,
                        decoration: const InputDecoration(labelText: "Tindakan", prefixIcon: Icon(Icons.medical_services)),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _obatController,
                        decoration: const InputDecoration(labelText: "Obat yang Diberikan", prefixIcon: Icon(Icons.medication)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800], foregroundColor: Colors.white),
                  onPressed: _simpanMedis,
                  child: const Text("SIMPAN RIWAYAT MEDIS", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}