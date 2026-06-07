class Yudisium {
  String? id;
  String mahasiswaId;
  String dokumenRevisi;
  String statusPembimbing;
  String statusYudisium;

  Yudisium({
    this.id,
    required this.mahasiswaId,
    required this.dokumenRevisi,
    required this.statusPembimbing,
    required this.statusYudisium,
  });

  factory Yudisium.fromJson(Map<String, dynamic> json) {
    return Yudisium(
      id: json['id']?.toString(),
      mahasiswaId: json['mahasiswaId'] ?? '',
      dokumenRevisi: json['dokumenRevisi'] ?? '',
      statusPembimbing: json['statusPembimbing'] ?? 'Menunggu',
      statusYudisium: json['statusYudisium'] ?? 'Proses Pengesahan',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'mahasiswaId': mahasiswaId,
      'dokumenRevisi': dokumenRevisi,
      'statusPembimbing': statusPembimbing,
      'statusYudisium': statusYudisium,
    };
  }
}
