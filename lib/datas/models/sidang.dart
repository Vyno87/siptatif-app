class Sidang {
  String? id;
  String mahasiswaId;
  String drafLaporan;
  String tanggalSidang;
  String waktuSidang;
  String ruangan;
  String status;

  Sidang({
    this.id,
    required this.mahasiswaId,
    required this.drafLaporan,
    required this.tanggalSidang,
    required this.waktuSidang,
    required this.ruangan,
    required this.status,
  });

  factory Sidang.fromJson(Map<String, dynamic> json) {
    return Sidang(
      id: json['id']?.toString(),
      mahasiswaId: json['mahasiswaId'] ?? '',
      drafLaporan: json['drafLaporan'] ?? '',
      tanggalSidang: json['tanggalSidang'] ?? '',
      waktuSidang: json['waktuSidang'] ?? '',
      ruangan: json['ruangan'] ?? '',
      status: json['status'] ?? 'Menunggu Jadwal',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'mahasiswaId': mahasiswaId,
      'drafLaporan': drafLaporan,
      'tanggalSidang': tanggalSidang,
      'waktuSidang': waktuSidang,
      'ruangan': ruangan,
      'status': status,
    };
  }
}
