class Sidang {
  String? id;
  String mahasiswaId;
  String drafLaporan;
  String tanggalSidang;
  String waktuSidang;
  String ruangan;
  String status;
  double? nilaiPenguji1;
  double? nilaiPenguji2;
  double? nilaiPembimbing;
  String? catatanRevisi;
  String? statusKelulusan;
  double? nilaiAkhir;

  Sidang({
    this.id,
    required this.mahasiswaId,
    required this.drafLaporan,
    required this.tanggalSidang,
    required this.waktuSidang,
    required this.ruangan,
    required this.status,
    this.nilaiPenguji1,
    this.nilaiPenguji2,
    this.nilaiPembimbing,
    this.catatanRevisi,
    this.statusKelulusan,
    this.nilaiAkhir,
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
      nilaiPenguji1: json['nilaiPenguji1']?.toDouble(),
      nilaiPenguji2: json['nilaiPenguji2']?.toDouble(),
      nilaiPembimbing: json['nilaiPembimbing']?.toDouble(),
      catatanRevisi: json['catatanRevisi'],
      statusKelulusan: json['statusKelulusan'],
      nilaiAkhir: json['nilaiAkhir']?.toDouble(),
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
      if (nilaiPenguji1 != null) 'nilaiPenguji1': nilaiPenguji1,
      if (nilaiPenguji2 != null) 'nilaiPenguji2': nilaiPenguji2,
      if (nilaiPembimbing != null) 'nilaiPembimbing': nilaiPembimbing,
      if (catatanRevisi != null) 'catatanRevisi': catatanRevisi,
      if (statusKelulusan != null) 'statusKelulusan': statusKelulusan,
      if (nilaiAkhir != null) 'nilaiAkhir': nilaiAkhir,
    };
  }
}
