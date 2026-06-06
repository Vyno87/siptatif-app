import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/pembimbing.dart';

class PembimbingProvider extends ChangeNotifier {
  final List<Pembimbing> _semuaPembimbing = [
    Pembimbing(
        nama: "Dr. Fulanah, S.T, M.Kom,.",
        nidn: "2145901302",
        jenisKelamin: "Perempuan",
        kuota: 7,
        keahlian: "Cyber Security"
    ),
    Pembimbing(
        nama: "Dr. Fulanah, S.T, M.Kom,.",
        nidn: "2145901302",
        jenisKelamin: "Perempuan",
        kuota: 4,
        keahlian: "Pemograman"
    ),
    Pembimbing(
        nama: "Dr. Fulanah, S.T, M.Kom,.",
        nidn: "2145901302",
        jenisKelamin: "Perempuan",
        kuota: 9,
        keahlian: "Desain Interaksi Antarmuka"
    ),
    Pembimbing(
        nama: "Dr. Fulanah, S.T, M.Kom,.",
        nidn: "2145901302",
        jenisKelamin: "Perempuan",
        kuota: 3,
        keahlian: "Cyber Security"
    ),
    Pembimbing(
        nama: "Dr. Fulanah, S.T, M.Kom,.",
        nidn: "2145901302",
        jenisKelamin: "Perempuan",
        kuota: 5,
        keahlian: "Cyber Security"
    ),
  ];

  List<Pembimbing> _displayedPembimbing = [];
  bool isLoading = false;
  String errorMessage = '';

  PembimbingProvider() {
    fetchPembimbing();
  }

  Future<void> fetchPembimbing() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _displayedPembimbing = List.from(_semuaPembimbing);
    } catch (e) {
      errorMessage = "Terjadi kesalahan saat memuat data pembimbing.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Pembimbing> get listPembimbing => _displayedPembimbing;

  void hapusPembimbing(Pembimbing p) {
    _semuaPembimbing.remove(p);
    _displayedPembimbing.remove(p);
    notifyListeners();
  }
}
