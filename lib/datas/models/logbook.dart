class Logbook {
  String? id;
  String mahasiswaId;
  String dosenNidn;
  String tanggal;
  String materiProgres;
  String catatanDosen;
  String status;

  Logbook({
    this.id,
    required this.mahasiswaId,
    required this.dosenNidn,
    required this.tanggal,
    required this.materiProgres,
    required this.catatanDosen,
    required this.status,
  });

  factory Logbook.fromJson(Map<String, dynamic> json) {
    return Logbook(
      id: json['id']?.toString(),
      mahasiswaId: json['mahasiswaId'] ?? '',
      dosenNidn: json['dosenNidn'] ?? '',
      tanggal: json['tanggal'] ?? '',
      materiProgres: json['materiProgres'] ?? '',
      catatanDosen: json['catatanDosen'] ?? '',
      status: json['status'] ?? 'Menunggu Validasi',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'mahasiswaId': mahasiswaId,
      'dosenNidn': dosenNidn,
      'tanggal': tanggal,
      'materiProgres': materiProgres,
      'catatanDosen': catatanDosen,
      'status': status,
    };
  }
}
