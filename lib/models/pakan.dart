class Pakan {
  final int? idLog;
  final String jenisPakan;
  final String kuantitas; 
  final String biaya;
  final String tanggal;
  final String keterangan;

  Pakan({
    this.idLog,
    required this.jenisPakan,
    required this.kuantitas,
    required this.biaya,
    required this.tanggal,
    this.keterangan = '-',
  });

  factory Pakan.fromJson(Map<String, dynamic> json) {
    return Pakan(
      idLog: json['id_log'] != null 
          ? int.tryParse(json['id_log'].toString()) 
          : null,
      
      // MAPPING KE KOLOM DATABASE BARU
      jenisPakan: json['jenis_pakan']?.toString() ?? '-',
      
      // Perhatikan: Key JSON harus sama persis dengan nama kolom di Database
      kuantitas: json['kuantitas_kg']?.toString() ?? '0', 
      biaya: json['biaya_rp']?.toString() ?? '0',         
      tanggal: json['tanggal_input']?.toString() ?? '-',  
      
      keterangan: json['keterangan']?.toString() ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_log': idLog,
      'jenis_pakan': jenisPakan,
      'kuantitas_kg': kuantitas, // Kirim balik sesuai nama kolom DB
      'biaya_rp': biaya,
      'tanggal_input': tanggal,
      'keterangan': keterangan,
    };
  }
}