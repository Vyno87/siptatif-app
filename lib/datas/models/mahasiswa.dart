class Mahasiswa {
  String tglDaftar;
  String jenisPendaftaran;
  String nama;
  String nim;
  String email;
  String judulTugasAkhir;
  String kategoriTugasAkhir;
  String calonDosenPembimbing1;
  String calonDosenPembimbing2;
  String berkas;
  String statusBerkas;
  String catatanUntukMahasiswa;

  Mahasiswa(
    {
      required this.tglDaftar,
      required this.jenisPendaftaran,
      required this.nama,
      required this.nim,
      required this.email,
      required this.judulTugasAkhir,
      required this.kategoriTugasAkhir,
      required this.calonDosenPembimbing1,
      required this.calonDosenPembimbing2,
      required this.berkas,
      required this.statusBerkas,
      required this.catatanUntukMahasiswa
    }
  );

}