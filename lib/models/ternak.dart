class Ternak {
  final int? idTernak;
  final String kodeTag;
  final String jenisTernak;
  final String jenisKelamin;
  final String status;
  final String tanggalLahir; 
  final String berat;
  final String fase;
  final String silsilah;

  Ternak({
    this.idTernak,
    required this.kodeTag,
    required this.jenisTernak,
    required this.jenisKelamin,
    required this.status,
    this.tanggalLahir = '-', 
    this.berat = '0',
    this.fase = '-',
    this.silsilah = '-',
  });

  factory Ternak.fromJson(Map<String, dynamic> json) {
    return Ternak(
      // Parsing ID agar aman (terima String atau Int)
      idTernak: json['id_ternak'] != null 
          ? int.tryParse(json['id_ternak'].toString()) 
          : null,
      
      // Ambil data dengan aman. Jika null, ganti '-'
      kodeTag: json['kode_tag']?.toString() ?? '-',
      jenisTernak: json['jenis_ternak']?.toString() ?? '-',
      jenisKelamin: json['jenis_kelamin']?.toString() ?? '-',
      status: json['status']?.toString() ?? 'Aktif',
      
      // PENTING: Key disini ('tgl_lahir') harus sama dengan PHP
      tanggalLahir: json['tgl_lahir']?.toString() ?? '-', 
      
      berat: json['berat']?.toString() ?? '0',
      fase: json['fase']?.toString() ?? '-',
      silsilah: json['silsilah']?.toString() ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ternak': idTernak,
      'kode_tag': kodeTag,
      'jenis_ternak': jenisTernak,
      'jenis_kelamin': jenisKelamin,
      'status': status,
      'tgl_lahir': tanggalLahir, // Kirim ke PHP sebagai tgl_lahir
      'berat': berat,
      'fase': fase,
      'silsilah': silsilah,
    };
  }
}