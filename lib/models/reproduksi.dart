class Reproduksi {
  final int? idReproduksi;
  final String idTernak;
  final String jenisKejadian; // Misal: Inseminasi, Melahirkan, Keguguran
  final String tanggal;
  final String hasil;         // Misal: Berhasil/Gagal/Menunggu
  final String catatan;

  Reproduksi({
    this.idReproduksi,
    required this.idTernak,
    required this.jenisKejadian,
    required this.tanggal,
    this.hasil = '-',
    this.catatan = '-',
  });

  factory Reproduksi.fromJson(Map<String, dynamic> json) {
    return Reproduksi(
      idReproduksi: json['id_reproduksi'] != null 
          ? int.tryParse(json['id_reproduksi'].toString()) 
          : null,
      
      // Ambil data dengan aman (Anti-Null)
      idTernak: json['id_ternak']?.toString() ?? '-',
      jenisKejadian: json['jenis_kejadian']?.toString() ?? '-',
      tanggal: json['tanggal']?.toString() ?? '-',
      hasil: json['hasil']?.toString() ?? '-',
      catatan: json['catatan']?.toString() ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_reproduksi': idReproduksi,
      'id_ternak': idTernak,
      'jenis_kejadian': jenisKejadian,
      'tanggal': tanggal,
      'hasil': hasil,
      'catatan': catatan,
    };
  }
}