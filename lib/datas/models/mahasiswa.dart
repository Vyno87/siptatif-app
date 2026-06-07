class Mahasiswa {
  String? id;
  String tglDaftar;
  String jenisPendaftaran;
  String nama;
  String nim;
  String email;
  String judulTugasAkhir;
  String kategoriTugasAkhir;
  String calonDosenPembimbing1;
  String calonDosenPembimbing2;
  String? dosenPenguji1;
  String? dosenPenguji2;
  String berkas;
  String statusBerkas;
  String catatanUntukMahasiswa;

  Mahasiswa(
    {
      this.id,
      required this.tglDaftar,
      required this.jenisPendaftaran,
      required this.nama,
      required this.nim,
      required this.email,
      required this.judulTugasAkhir,
      required this.kategoriTugasAkhir,
      required this.calonDosenPembimbing1,
      required this.calonDosenPembimbing2,
      this.dosenPenguji1,
      this.dosenPenguji2,
      required this.berkas,
      required this.statusBerkas,
      required this.catatanUntukMahasiswa
    }
  );

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['id']?.toString(),
      tglDaftar: json['tglDaftar'] ?? '',
      jenisPendaftaran: json['jenisPendaftaran'] ?? '',
      nama: json['nama'] ?? '',
      nim: json['nim'] ?? '',
      email: json['email'] ?? '',
      judulTugasAkhir: json['judulTugasAkhir'] ?? '',
      kategoriTugasAkhir: json['kategoriTugasAkhir'] ?? '',
      calonDosenPembimbing1: json['calonDosenPembimbing1'] ?? '',
      calonDosenPembimbing2: json['calonDosenPembimbing2'] ?? '',
      dosenPenguji1: json['dosenPenguji1'],
      dosenPenguji2: json['dosenPenguji2'],
      berkas: json['berkas'] ?? '',
      statusBerkas: json['statusBerkas'] ?? '',
      catatanUntukMahasiswa: json['catatanUntukMahasiswa'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'tglDaftar': tglDaftar,
      'jenisPendaftaran': jenisPendaftaran,
      'nama': nama,
      'nim': nim,
      'email': email,
      'judulTugasAkhir': judulTugasAkhir,
      'kategoriTugasAkhir': kategoriTugasAkhir,
      'calonDosenPembimbing1': calonDosenPembimbing1,
      'calonDosenPembimbing2': calonDosenPembimbing2,
      if (dosenPenguji1 != null) 'dosenPenguji1': dosenPenguji1,
      if (dosenPenguji2 != null) 'dosenPenguji2': dosenPenguji2,
      'berkas': berkas,
      'statusBerkas': statusBerkas,
      'catatanUntukMahasiswa': catatanUntukMahasiswa,
    };
  }
}