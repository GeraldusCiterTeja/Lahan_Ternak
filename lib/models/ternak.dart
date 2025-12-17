class Ternak {
  final int? idTernak; // Nullable, karena ID di-generate oleh database
  final String kodeTag;
  final String jenisTernak;
  final String tanggalLahir;
  final String? silsilah;
  final String jenisKelamin;
  final String status;

  Ternak({
    this.idTernak,
    required this.kodeTag,
    required this.jenisTernak,
    required this.tanggalLahir,
    this.silsilah,
    required this.jenisKelamin,
    required this.status,
  });

  // Factory Constructor: Konversi JSON (dari API) ke Objek Dart
  factory Ternak.fromJson(Map<String, dynamic> json) {
    return Ternak(
      idTernak: int.tryParse(json['id_ternak'].toString()), // Konversi string dari PHP ke int
      kodeTag: json['kode_tag'] as String,
      jenisTernak: json['jenis_ternak'] as String,
      tanggalLahir: json['tanggal_lahir'] as String,
      silsilah: json['silsilah'] as String?,
      jenisKelamin: json['jenis_kelamin'] as String,
      status: json['status'] as String,
    );
  }

  // Method: Konversi Objek Dart ke Map/JSON (untuk dikirim ke API)
  Map<String, dynamic> toJson() {
    return {
      'id_ternak': idTernak,
      'kode_tag': kodeTag,
      'jenis_ternak': jenisTernak,
      'tanggal_lahir': tanggalLahir,
      'silsilah': silsilah,
      'jenis_kelamin': jenisKelamin,
      'status': status,
    };
  }
}