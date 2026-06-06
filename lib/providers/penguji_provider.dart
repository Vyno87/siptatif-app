import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/penguji.dart';

class PengujiProvider extends ChangeNotifier {
  final List<Penguji> _semuaPenguji = [
    Penguji(
      nama: "Dr. Fulanah, S.T, M.Kom,.",
      nidn: "2145901302",
      jenisKelamin: "Perempuan",
      kuota: 7,
      keahlian: "Cyber Security"
    ),
    Penguji(
        nama: "Dr. Fulanah, S.T, M.Kom,.",
        nidn: "2145901302",
        jenisKelamin: "Perempuan",
        kuota: 4,
        keahlian: "Pemograman"
    ),
    Penguji(
        nama: "Dr. Fulanah, S.T, M.Kom,.",
        nidn: "2145901302",
        jenisKelamin: "Perempuan",
        kuota: 9,
        keahlian: "Desain Interaksi Antarmuka"
    ),
    Penguji(
        nama: "Dr. Fulanah, S.T, M.Kom,.",
        nidn: "2145901302",
        jenisKelamin: "Perempuan",
        kuota: 3,
        keahlian: "Cyber Security"
    ),
    Penguji(
        nama: "Dr. Fulanah, S.T, M.Kom,.",
        nidn: "2145901302",
        jenisKelamin: "Perempuan",
        kuota: 5,
        keahlian: "Cyber Security"
    ),
  ];

  List<Penguji> _displayedPenguji = [];
  bool isLoading = false;
  String errorMessage = '';

  PengujiProvider() {
    fetchPenguji();
  }

  Future<void> fetchPenguji() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _displayedPenguji = List.from(_semuaPenguji);
    } catch (e) {
      errorMessage = "Terjadi kesalahan saat memuat data penguji.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Penguji> get listPenguji => _displayedPenguji;

  void hapusPenguji(Penguji p) {
    _semuaPenguji.remove(p);
    _displayedPenguji.remove(p);
    notifyListeners();
  }
}
