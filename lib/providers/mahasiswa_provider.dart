import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';

class MahasiswaProvider extends ChangeNotifier {
  final List<Mahasiswa> _semuaMahasiswa = [
    Mahasiswa(
      tglDaftar: "23-03-2024",
      jenisPendaftaran: "Individu",
      nama: "M. Farhan Aulia Pratama",
      nim: "12250113521",
      email: "farhanaulia.p@gmail.com",
      judulTugasAkhir: "Rancang Bangun Sistem SIPTATIF Berbasis Framework Flutter",
      kategoriTugasAkhir: "Laporan",
      calonDosenPembimbing1: "Dr. Fulanah, S.T, M.Kom,.",
      calonDosenPembimbing2: "Dr. Fulanah, S.T, M.Kom,.",
      berkas: "assets/berkas/12250113521.pdf",
      statusBerkas: "Disetujui",
      catatanUntukMahasiswa: "Sudah Bagus",
    ),
    Mahasiswa(
      tglDaftar: "23-03-2024",
      jenisPendaftaran: "Individu",
      nama: "M. Farhan Aulia Pratama",
      nim: "12250113521",
      email: "farhanaulia.p@gmail.com",
      judulTugasAkhir: "Robot Pemadam Api Berbasis Arduino Dengan Sensor Ultrasonik",
      kategoriTugasAkhir: "Laporan",
      calonDosenPembimbing1: "Dr. Fulanah, S.T, M.Kom,.",
      calonDosenPembimbing2: "Dr. Fulanah, S.T, M.Kom,.",
      berkas: "assets/berkas/12250113521.pdf",
      statusBerkas: "Ditolak",
      catatanUntukMahasiswa: "Sudah Bagus",
    ),
    Mahasiswa(
      tglDaftar: "23-03-2024",
      jenisPendaftaran: "Individu",
      nama: "M. Farhan Aulia Pratama",
      nim: "12250113521",
      email: "farhanaulia.p@gmail.com",
      judulTugasAkhir: "Klasifikasi Tingkat Demam Berdarah Menggunakan Metode Naive Bayes Classifier untuk Deteksi Dini",
      kategoriTugasAkhir: "Laporan",
      calonDosenPembimbing1: "Dr. Fulanah, S.T, M.Kom,.",
      calonDosenPembimbing2: "Dr. Fulanah, S.T, M.Kom,.",
      berkas: "assets/berkas/12250113521.pdf",
      statusBerkas: "Menunggu",
      catatanUntukMahasiswa: "Sudah Bagus",
    ),
    Mahasiswa(
      tglDaftar: "23-03-2024",
      jenisPendaftaran: "Individu",
      nama: "M. Farhan Aulia Pratama",
      nim: "12250113521",
      email: "farhanaulia.p@gmail.com",
      judulTugasAkhir: "Sistem Informasi Perpustakaan Ponpes Daar al-Qalam Semarang Berbasis Web",
      kategoriTugasAkhir: "Laporan",
      calonDosenPembimbing1: "Dr. Fulanah, S.T, M.Kom,.",
      calonDosenPembimbing2: "Dr. Fulanah, S.T, M.Kom,.",
      berkas: "assets/berkas/12250113521.pdf",
      statusBerkas: "Ditolak",
      catatanUntukMahasiswa: "Sudah Bagus",
    ),
    Mahasiswa(
      tglDaftar: "23-03-2024",
      jenisPendaftaran: "Individu",
      nama: "M. Farhan Aulia Pratama",
      nim: "12250113521",
      email: "farhanaulia.p@gmail.com",
      judulTugasAkhir: "Penerapan Algoritma Particle Swarm Optimization (PSO) Dalam Mendeteksi kekerasan Plat Baja Karbon",
      kategoriTugasAkhir: "Laporan",
      calonDosenPembimbing1: "Dr. Fulanah, S.T, M.Kom,.",
      calonDosenPembimbing2: "Dr. Fulanah, S.T, M.Kom,.",
      berkas: "assets/berkas/12250113521.pdf",
      statusBerkas: "Disetujui",
      catatanUntukMahasiswa: "Sudah Bagus",
    ),
  ];

  List<Mahasiswa> _displayedMahasiswa = [];
  String _searchKeyword = "";

  MahasiswaProvider() {
    _displayedMahasiswa = List.from(_semuaMahasiswa);
  }

  List<Mahasiswa> get listMahasiswa => _displayedMahasiswa;

  void runFilter(String enteredKeyword) {
    _searchKeyword = enteredKeyword;
    if (_searchKeyword.isEmpty) {
      _displayedMahasiswa = List.from(_semuaMahasiswa);
    } else {
      _displayedMahasiswa = _semuaMahasiswa
          .where((mhs) =>
              mhs.nama.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
              mhs.nim.contains(_searchKeyword))
          .toList();
    }
    notifyListeners();
  }
}
