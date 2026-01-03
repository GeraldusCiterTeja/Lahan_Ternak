class Kesehatan {
  final int? idKesehatan;
  final String idTernak;
  final String diagnosa;       // SESUAIKAN: Dulu 'keluhan'
  final String obat;
  final String tanggalPeriksa; // SESUAIKAN: Dulu 'tanggal'
  final String tindakan;       // SESUAIKAN: Dulu 'catatan'

  Kesehatan({
    this.idKesehatan,
    required this.idTernak,
    required this.diagnosa,
    required this.obat,
    required this.tanggalPeriksa,
    this.tindakan = '-',
  });

  factory Kesehatan.fromJson(Map<String, dynamic> json) {
    return Kesehatan(
      idKesehatan: json['id_kesehatan'] != null 
          ? int.tryParse(json['id_kesehatan'].toString()) 
          : null,
      
      // Ambil data dengan aman (Anti-Null)
      idTernak: json['id_ternak']?.toString() ?? '-',
      
      // PENTING: Key di sini ('diagnosa') harus sama persis dengan kolom Database
      diagnosa: json['diagnosa']?.toString() ?? '-', 
      obat: json['obat']?.toString() ?? '-',
      tanggalPeriksa: json['tanggal_periksa']?.toString() ?? '-',
      tindakan: json['tindakan']?.toString() ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kesehatan': idKesehatan,
      'id_ternak': idTernak,
      'diagnosa': diagnosa,
      'obat': obat,
      'tanggal_periksa': tanggalPeriksa,
      'tindakan': tindakan,
    };
  }
}