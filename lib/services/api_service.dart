import 'dart:convert';
import 'dart:io'; // Wajib untuk File Foto
import 'package:http/http.dart' as http;

import '../models/ternak.dart';
import '../models/pakan.dart';
import '../models/kesehatan.dart';

class ApiService {
  // Ganti localhost dengan IP Laptop jika di HP Asli.
  // Jika di Emulator Android Studio, gunakan 10.0.2.2
  final String baseUrl = "http://localhost/lahan_ternak_api"; 

  // --- HELPER UNTUK DECODE JSON ---
  List<dynamic> _decodeList(String responseBody) {
    try {
      dynamic decoded = jsonDecode(responseBody);
      // Jika formatnya langsung List [...]
      if (decoded is List) return decoded;
      // Jika formatnya Object { "data": [...] }
      if (decoded is Map && decoded.containsKey('data')) return decoded['data'];
      return [];
    } catch (e) {
      return [];
    }
  }

  // ===========================================================================
  // 1. AUTH (LOGIN, REGISTER, UPDATE PROFIL)
  // ===========================================================================
  
  // Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Koneksi Error: $e'};
    }
  }

  // Register (Dengan Nama Kandang & Lokasi)
Future<Map<String, dynamic>> register(
    String nama, String username, String password, String namaKandang, String lokasi, File? imageFile
  ) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/register.php'));
      
      // Kirim Data Teks
      request.fields['nama_lengkap'] = nama;
      request.fields['username'] = username;
      request.fields['password'] = password;
      request.fields['nama_kandang'] = namaKandang;
      request.fields['lokasi'] = lokasi;

      // Kirim File Foto (Jika user memilih foto)
      if (imageFile != null) {
        var pic = await http.MultipartFile.fromPath('foto', imageFile.path);
        request.files.add(pic);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error Upload: $e'};
    }
  }

  // Update Profil (Support Upload Foto)
  Future<Map<String, dynamic>> updateProfile(
    String idUser, String nama, String kandang, String lokasi, File? imageFile
  ) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/update_profile.php'));
      
      // Kirim Data Teks
      request.fields['id_user'] = idUser;
      request.fields['nama_lengkap'] = nama;
      request.fields['nama_kandang'] = kandang;
      request.fields['lokasi'] = lokasi;

      // Kirim File Foto (Jika user memilih foto baru)
      if (imageFile != null) {
        var pic = await http.MultipartFile.fromPath('foto', imageFile.path);
        request.files.add(pic);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error Upload: $e'};
    }
  }

  // ===========================================================================
  // 2. MODUL TERNAK (CRUD)
  // ===========================================================================
  Future<List<Ternak>> fetchTernak() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ternak_read.php'));
      if (response.statusCode == 200) {
        return _decodeList(response.body).map((x) => Ternak.fromJson(x)).toList();
      }
      return [];
    } catch (e) { return []; }
  }
  
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
  // 3. MODUL PAKAN
  // ===========================================================================
  Future<List<Pakan>> fetchPakan() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pakan_read.php'));
      if (response.statusCode == 200) {
        return _decodeList(response.body).map((x) => Pakan.fromJson(x)).toList();
      }
      return [];
    } catch (e) { return []; }
  }

  Future<bool> createPakan(Pakan data) async {
    final response = await http.post(Uri.parse('$baseUrl/pakan_create.php'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data.toJson()));
    return response.statusCode == 200;
  }

  // ===========================================================================
  // 4. MODUL KESEHATAN
  // ===========================================================================
  Future<List<Kesehatan>> fetchKesehatan() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/kesehatan_read.php'));
      if (response.statusCode == 200) {
        return _decodeList(response.body).map((x) => Kesehatan.fromJson(x)).toList();
      }
      return [];
    } catch (e) { return []; }
  }

  Future<bool> createKesehatan(Kesehatan data) async {
    final response = await http.post(Uri.parse('$baseUrl/kesehatan_create.php'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data.toJson()));
    return response.statusCode == 200;
  }
}