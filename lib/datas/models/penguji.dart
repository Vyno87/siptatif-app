class Penguji {
  String? id;
  String nama;
  String nidn;
  String jenisKelamin;
  int kuota;
  String keahlian;
  
  Penguji(
      {
        this.id,
        required this.nama,
        required this.nidn,
        required this.jenisKelamin,
        required this.kuota,
        required this.keahlian,
      }
      );

  factory Penguji.fromJson(Map<String, dynamic> json) {
    return Penguji(
      id: json['id']?.toString(),
      nama: json['nama'] ?? '',
      nidn: json['nidn'] ?? '',
      jenisKelamin: json['jenisKelamin'] ?? '',
      kuota: json['kuota'] ?? 0,
      keahlian: json['keahlian'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama': nama,
      'nidn': nidn,
      'jenisKelamin': jenisKelamin,
      'kuota': kuota,
      'keahlian': keahlian,
    };
  }
}