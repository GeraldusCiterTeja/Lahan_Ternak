import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/ternak.dart';
import '../models/pakan.dart';
import '../models/kesehatan.dart';
import '../models/reproduksi.dart';

class ApiService {
  // Pastikan URL ini benar. Jika pakai Android Emulator gunakan 10.0.2.2
  final String baseUrl = "http://localhost/lahan_ternak_api"; 

  // --- HELPER UNTUK DECODE DATA ---
  List<dynamic> _decodeList(String responseBody, String contextName) {
    try {
      print("[$contextName] RAW RESPONSE: $responseBody"); // <-- Debugging
      
      dynamic decoded = jsonDecode(responseBody);
      
      // Kasus 1: Format Langsung List [...]
      if (decoded is List) {
        return decoded;
      } 
      // Kasus 2: Format Object { "data": [...] }
      else if (decoded is Map && decoded.containsKey('data')) {
        return decoded['data'];
      }
      // Kasus 3: Error atau Format Salah
      else {
        print("[$contextName] Warning: Format JSON bukan List.");
        return [];
      }
    } catch (e) {
      print("[$contextName] Error Decode JSON: $e");
      return [];
    }
  }

  // ===========================================================================
  // 1. TERNAK
  // ===========================================================================
  Future<List<Ternak>> fetchTernak() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ternak_read.php'));
      if (response.statusCode == 200) {
        List<dynamic> body = _decodeList(response.body, "Ternak");
        return body.map((item) => Ternak.fromJson(item)).toList();
      } else {
        throw Exception("Gagal Load Ternak: ${response.statusCode}");
      }
    } catch (e) {
      print("Error Fetch Ternak: $e");
      return [];
    }
  }
  
  // Create, Update, Delete Ternak (Kode sebelumnya...)
  Future<bool> createTernak(Ternak data) async {
    final response = await http.post(Uri.parse('$baseUrl/ternak_create.php'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data.toJson()));
    return response.statusCode == 200;
  }
  Future<bool> updateTernak(Ternak data) async {
    final response = await http.post(Uri.parse('$baseUrl/ternak_update.php'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data.toJson()));
    return response.statusCode == 200;
  }
  Future<bool> deleteTernak(int id) async {
    final response = await http.post(Uri.parse('$baseUrl/ternak_delete.php'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'id_ternak': id}));
    return response.statusCode == 200;
  }

  // ===========================================================================
  // 2. PAKAN (Fokus Perbaikan)
  // ===========================================================================
  Future<List<Pakan>> fetchPakan() async {
    try {
      final url = Uri.parse('$baseUrl/pakan_read.php');
      print("[Pakan] Request ke: $url"); // Cek URL

      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        // Decode menggunakan Helper
        List<dynamic> body = _decodeList(response.body, "Pakan");
        
        // Mapping ke Model
        return body.map((item) {
          try {
            return Pakan.fromJson(item);
          } catch (e) {
            print("[Pakan] Error Mapping Item: $e | Data: $item");
            // Kembalikan data dummy/null agar list tetap jalan
             return Pakan(jenisPakan: 'Error Data', kuantitas: '0', biaya: '0', tanggal: '-', idLog: 0); 
          }
        }).toList();
      } else {
        print("[Pakan] Server Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("[Pakan] Error Fetch: $e");
      return [];
    }
  }

  Future<bool> createPakan(Pakan data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pakan_create.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson()),
      );
      print("[Pakan Create] Response: ${response.body}");
      return response.statusCode == 200;
    } catch (e) {
      print("[Pakan Create] Error: $e");
      return false;
    }
  }

  // ===========================================================================
  // 3. KESEHATAN
  // ===========================================================================
  Future<List<Kesehatan>> fetchKesehatan() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/kesehatan_read.php'));
      if (response.statusCode == 200) {
        List<dynamic> body = _decodeList(response.body, "Kesehatan");
        return body.map((item) => Kesehatan.fromJson(item)).toList();
      } else { return []; }
    } catch (e) { return []; }
  }

  Future<bool> createKesehatan(Kesehatan data) async {
    final response = await http.post(Uri.parse('$baseUrl/kesehatan_create.php'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data.toJson()));
    return response.statusCode == 200;
  }

  // ===========================================================================
  // 4. REPRODUKSI
  // ===========================================================================
  Future<List<Reproduksi>> fetchReproduksi() async {
     try {
      final response = await http.get(Uri.parse('$baseUrl/reproduksi_read.php'));
      if (response.statusCode == 200) {
        List<dynamic> body = _decodeList(response.body, "Reproduksi");
        return body.map((item) => Reproduksi.fromJson(item)).toList();
      } else { return []; }
    } catch (e) { return []; }
  }

  Future<bool> createReproduksi(Reproduksi data) async {
    final response = await http.post(Uri.parse('$baseUrl/reproduksi_create.php'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data.toJson()));
    return response.statusCode == 200;
  }
}