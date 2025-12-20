import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ternak.dart';

// =================================================================
// PENTING: Konfigurasi URL API
// =================================================================

// Ganti IP ini dengan IP lokal Host Anda jika menggunakan Android Emulator, 
// atau ganti dengan http://lahan-ternak-api.test jika menggunakan Flutter Web di Chrome.
const String _baseUrl = "http://localhost/lahan_ternak_api"; 


class ApiService {

  // FUNGSI 1: READ - Mengambil semua data ternak
  Future<List<Ternak>> fetchTernak() async {
    final response = await http.get(Uri.parse('$_baseUrl/ternak_read.php'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        return (jsonResponse['data'] as List)
            .map((item) => Ternak.fromJson(item))
            .toList();
      }
      return []; 
    } else {
      throw Exception('Gagal memuat data ternak. Status Code: ${response.statusCode}');
    }
  }

  // FUNGSI 2: CREATE - Menambahkan data ternak baru
  Future<bool> createTernak(Ternak ternak) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ternak_create.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ternak.toJson()),
    );
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['success'] == true;
    }
    return false;
  }

  // FUNGSI 3: UPDATE - Mengubah data ternak yang sudah ada
  Future<bool> updateTernak(Ternak ternak) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/ternak_update.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ternak.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['success'] == true; 
    }
    return false;
  }

  // FUNGSI 4: DELETE - Menghapus data ternak
  Future<bool> deleteTernak(int id) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ternak_delete.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id_ternak": id}),
    );
    return jsonDecode(response.body)['success'] == true;
  }

  // Tambahkan import model kesehatan nanti
  Future<List<dynamic>> fetchKesehatan() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/kesehatan_read.php'));

      if (response.statusCode == 200) {
        // Cek apakah respon benar-benar JSON
        if (response.body.startsWith('<')) {
          print("Error dari PHP: ${response.body}"); // Ini akan muncul di Console VS Code
          throw Exception("Server mengirim HTML, bukan JSON. Cek log PHP.");
        }
        
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        return decoded['data'] ?? [];
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Caught Error: $e");
      return [];
    }
  }
  Future<bool> createKesehatan(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/kesehatan_create.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body)['success'] == true;
  }

  Future<List<dynamic>> fetchPakan() async {
    final response = await http.get(Uri.parse('$_baseUrl/pakan_read.php'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'] ?? [];
    }
    return [];
  }

  Future<bool> createPakan(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/pakan_create.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body)['success'] == true;
  }

  Future<List<dynamic>> fetchReproduksi() async {
    final response = await http.get(Uri.parse('$_baseUrl/reproduksi_read.php'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'] ?? [];
    }
    return [];
  }

  Future<bool> createReproduksi(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/reproduksi_create.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body)['success'] == true;
  }
}